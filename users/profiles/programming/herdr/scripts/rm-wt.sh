#!/usr/bin/env sh
# Remove a herdr git worktree and, when safe, delete its branch.
set -eu

usage() {
  cat <<'EOF'
Usage: rm-wt [<slug>] [--branch <branch>] [--force] [--cwd <dir>]

Removes a herdr worktree checkout and deletes its branch when the branch is
merged or pushed. With no argument the worktree you are currently in is used;
that case is delegated to another workspace so the removal can outlive the
session it is running in.

Options:
  <slug>            Target branch worktree/<slug>.
  --branch <branch> Target an explicit branch instead of worktree/<slug>.
  --force           Remove a dirty checkout and delete an unmerged branch.
  --cwd <dir>       Directory inside the target repo. Default: current directory.
  --no-delegate     Internal. Never delegate a self-removal.
  -h, --help        Show this help.
EOF
}

slug=
branch=
cwd=
force=0
no_delegate=0

while [ $# -gt 0 ]; do
  case "$1" in
    --slug)
      slug=${2:-}
      shift 2
      ;;
    --branch)
      branch=${2:-}
      shift 2
      ;;
    --cwd)
      cwd=${2:-}
      shift 2
      ;;
    --force)
      force=1
      shift
      ;;
    --no-delegate)
      no_delegate=1
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      printf 'rm-wt: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
    *)
      if [ -n "$slug" ] || [ -n "$branch" ]; then
        printf 'rm-wt: unexpected argument: %s\n' "$1" >&2
        exit 2
      fi
      slug=$1
      shift
      ;;
  esac
done

if [ -z "$branch" ] && [ -n "$slug" ]; then
  branch="worktree/$slug"
fi

if [ -z "$cwd" ]; then
  cwd=$PWD
fi

if [ ! -d "$cwd" ]; then
  printf 'rm-wt: --cwd is not a directory: %s\n' "$cwd" >&2
  exit 2
fi

git_common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
  printf 'rm-wt: %s is not inside a git repository\n' "$cwd" >&2
  exit 1
}
repo_root=$(dirname "$git_common")

current_toplevel=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null) || {
  printf 'rm-wt: could not resolve the current worktree\n' >&2
  exit 1
}
current_real=$(realpath "$current_toplevel")

if [ -z "$branch" ]; then
  if [ "$(realpath "$repo_root")" = "$current_real" ]; then
    printf 'rm-wt: current directory is the primary checkout; pass a slug to remove a worktree\n' >&2
    exit 1
  fi
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null) || {
    printf 'rm-wt: could not resolve the current branch\n' >&2
    exit 1
  }
  if [ "$branch" = "HEAD" ]; then
    printf 'rm-wt: current worktree is in detached HEAD; pass a slug\n' >&2
    exit 1
  fi
fi

if ! wt_json=$(herdr worktree list --cwd "$repo_root" 2>&1); then
  printf 'rm-wt: herdr worktree list failed\n' >&2
  printf '%s\n' "$wt_json" >&2
  exit 1
fi

target_json=$(printf '%s' "$wt_json" | jq -c --arg b "$branch" 'first(.result.worktrees[]? | select(.branch == $b)) // empty' 2>/dev/null || true)
if [ -z "$target_json" ]; then
  printf 'rm-wt: no worktree found for branch %s\n' "$branch" >&2
  exit 1
fi

target_path=$(printf '%s' "$target_json" | jq -r '.path')
target_ws=$(printf '%s' "$target_json" | jq -r '.open_workspace_id // empty')

if [ -n "$target_path" ] && [ -d "$target_path" ] && [ -n "$(git -C "$target_path" status --porcelain 2>/dev/null)" ]; then
  dirty=1
else
  dirty=0
fi

base_ref=
if git -C "$repo_root" rev-parse --verify --quiet origin/HEAD >/dev/null 2>&1; then
  base_ref=origin/HEAD
elif git -C "$repo_root" rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
  base_ref=origin/main
elif git -C "$repo_root" rev-parse --verify --quiet main >/dev/null 2>&1; then
  base_ref=main
fi

merged=0
if [ -n "$base_ref" ] && git -C "$repo_root" merge-base --is-ancestor "$branch" "$base_ref" 2>/dev/null; then
  merged=1
fi

pushed=0
if [ -n "$(git -C "$repo_root" branch -r --contains "$branch" 2>/dev/null)" ]; then
  pushed=1
fi

if [ "$force" -eq 0 ]; then
  if [ "$dirty" -eq 1 ]; then
    printf 'rm-wt: %s has uncommitted changes; re-run with --force to discard them\n' "$target_path" >&2
    exit 1
  fi
  if [ "$merged" -eq 0 ] && [ "$pushed" -eq 0 ]; then
    printf 'rm-wt: branch %s is not merged into %s and not pushed; re-run with --force to delete it\n' "$branch" "${base_ref:-the default branch}" >&2
    exit 1
  fi
fi

self=0
if [ -n "$target_path" ] && [ "$(realpath "$target_path" 2>/dev/null || printf '%s' "$target_path")" = "$current_real" ]; then
  self=1
fi

if [ "$self" -eq 1 ] && [ "$no_delegate" -eq 0 ]; then
  host_ws=$(printf '%s' "$wt_json" | jq -r '.result.source.source_workspace_id // empty')

  if [ -n "$host_ws" ] && [ "$host_ws" != "$target_ws" ]; then
    if ! tab_json=$(herdr tab create --workspace "$host_ws" --cwd "$repo_root" --label rm-wt --no-focus 2>&1); then
      printf 'rm-wt: could not create a delegate tab in workspace %s\n' "$host_ws" >&2
      printf '%s\n' "$tab_json" >&2
      exit 1
    fi
    pane=$(printf '%s' "$tab_json" | jq -r '.result.root_pane.pane_id // empty')
    if [ -n "$pane" ]; then
      cmd="rm-wt --branch '$branch' --cwd '$repo_root' --no-delegate"
      if [ "$force" -eq 1 ]; then
        cmd="$cmd --force"
      fi
      sleep 1
      herdr pane run "$pane" "$cmd" >/dev/null 2>&1 || true
      printf 'rm-wt: delegated removal of %s to workspace %s; this session will close\n' "$branch" "$host_ws"
      exit 0
    fi
  fi

  self_path=$(command -v rm-wt 2>/dev/null || printf '%s' "$0")
  set -- --branch "$branch" --cwd "$repo_root" --no-delegate
  if [ "$force" -eq 1 ]; then
    set -- "$@" --force
  fi
  setsid "$self_path" "$@" >/dev/null 2>&1 </dev/null &
  printf 'rm-wt: scheduled removal of %s in the background; this session will close\n' "$branch"
  exit 0
fi

if [ -n "$target_ws" ]; then
  set -- --workspace "$target_ws"
  if [ "$force" -eq 1 ]; then
    set -- "$@" --force
  fi
  if ! rm_json=$(herdr worktree remove "$@" 2>&1); then
    printf 'rm-wt: herdr worktree remove failed\n' >&2
    printf '%s\n' "$rm_json" >&2
    exit 1
  fi
else
  set -- "$target_path"
  if [ "$force" -eq 1 ]; then
    set -- --force "$@"
  fi
  if ! git -C "$repo_root" worktree remove "$@"; then
    printf 'rm-wt: git worktree remove failed\n' >&2
    exit 1
  fi
fi

printf 'rm-wt: removed checkout %s\n' "$target_path"

if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
  git -C "$repo_root" branch -D "$branch"
  printf 'rm-wt: deleted branch %s\n' "$branch"
else
  printf 'rm-wt: branch %s does not exist\n' "$branch"
fi

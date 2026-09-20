#!/usr/bin/env sh
# Create a herdr git worktree and inject a prompt into the agent started there.
set -eu

usage() {
  cat <<'EOF'
Usage: new-wt --slug <slug> [--base <ref>] [--cwd <dir>]

Creates a herdr git worktree on branch worktree/<slug> and submits a prompt,
read from stdin, to the agent that the auto-tabs plugin starts in the new
workspace.

Options:
  --slug <slug>   Required. Lowercase words joined by single dashes, max 40 chars.
  --base <ref>    Branch base. Default: origin/HEAD after a git fetch.
  --cwd <dir>     Directory inside the target repo. Default: current directory.
  -h, --help      Show this help.
EOF
}

slug=
base=
cwd=

while [ $# -gt 0 ]; do
  case "$1" in
    --slug)
      slug=${2:-}
      shift 2
      ;;
    --base)
      base=${2:-}
      shift 2
      ;;
    --cwd)
      cwd=${2:-}
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'new-wt: unknown argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "$slug" ]; then
  printf 'new-wt: --slug is required\n' >&2
  exit 2
fi

if ! printf '%s' "$slug" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  printf 'new-wt: invalid slug %s (expected lowercase words joined by single dashes)\n' "$slug" >&2
  exit 2
fi

if [ "${#slug}" -gt 40 ]; then
  printf 'new-wt: slug is longer than 40 characters\n' >&2
  exit 2
fi

if [ -z "$cwd" ]; then
  cwd=$PWD
fi

if [ ! -d "$cwd" ]; then
  printf 'new-wt: --cwd is not a directory: %s\n' "$cwd" >&2
  exit 2
fi

prompt=$(cat)
if [ -z "$prompt" ]; then
  printf 'new-wt: empty prompt on stdin\n' >&2
  exit 2
fi

git_common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null) || {
  printf 'new-wt: %s is not inside a git repository\n' "$cwd" >&2
  exit 1
}
repo_root=$(dirname "$git_common")

# Best-effort refresh; fall back to whatever refs exist when offline.
git -C "$repo_root" fetch origin --quiet 2>/dev/null || true

if [ -z "$base" ]; then
  if base=$(git -C "$repo_root" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null); then
    :
  elif git -C "$repo_root" rev-parse --verify --quiet origin/main >/dev/null 2>&1; then
    base=origin/main
  elif git -C "$repo_root" rev-parse --verify --quiet main >/dev/null 2>&1; then
    base=main
  else
    base=HEAD
  fi
fi

# Avoid reusing an existing branch or checkout path; suffix until free.
candidate=$slug
n=1
while :; do
  branch="worktree/$candidate"
  branch_slug="worktree-$candidate"
  clash=0
  if git -C "$repo_root" show-ref --verify --quiet "refs/heads/$branch"; then
    clash=1
  elif git -C "$repo_root" worktree list --porcelain | grep -E "^worktree .*/$branch_slug\$" >/dev/null; then
    clash=1
  fi
  if [ "$clash" -eq 0 ]; then
    break
  fi
  n=$((n + 1))
  candidate="$slug-$n"
done

printf 'new-wt: creating %s from %s\n' "$branch" "$base" >&2

if ! create_json=$(herdr worktree create \
  --cwd "$repo_root" \
  --branch "$branch" \
  --base "$base" \
  --label "$candidate" \
  --no-focus 2>&1); then
  printf 'new-wt: herdr worktree create failed\n' >&2
  printf '%s\n' "$create_json" >&2
  exit 1
fi

ws=$(printf '%s' "$create_json" | jq -r '.result.workspace.workspace_id // empty' 2>/dev/null || true)
wt_path=$(printf '%s' "$create_json" | jq -r '.result.worktree.path // empty' 2>/dev/null || true)

if [ -z "$ws" ]; then
  printf 'new-wt: could not read workspace id from herdr response\n' >&2
  printf '%s\n' "$create_json" >&2
  exit 1
fi

# The auto-tabs plugin starts the agent asynchronously; wait for it to appear.
pane=
deadline=$(( $(date +%s) + 60 ))
while [ "$(date +%s)" -lt "$deadline" ]; do
  pane=$(herdr agent list 2>/dev/null | jq -r --arg ws "$ws" 'first(.result.agents[]? | select(.workspace_id == $ws) | .pane_id) // empty' 2>/dev/null || true)
  if [ -n "$pane" ]; then
    break
  fi
  sleep 1
done

if [ -z "$pane" ]; then
  printf 'new-wt: worktree created but no agent appeared in workspace %s\n' "$ws" >&2
  printf 'new-wt: branch=%s path=%s workspace=%s\n' "$branch" "$wt_path" "$ws" >&2
  printf 'new-wt: is the matte.auto-tabs herdr plugin enabled?\n' >&2
  exit 1
fi

# Give the agent a moment to reach an interactive prompt before submitting.
herdr agent wait "$pane" --until idle --until "done" --timeout 30000 >/dev/null 2>&1 || true

if ! prompt_err=$(herdr agent prompt "$pane" "$prompt" --wait --timeout 120000 2>&1 >/dev/null); then
  printf 'new-wt: failed to submit prompt to %s\n' "$pane" >&2
  printf '%s\n' "$prompt_err" >&2
  printf 'new-wt: branch=%s path=%s workspace=%s pane=%s\n' "$branch" "$wt_path" "$ws" "$pane" >&2
  exit 1
fi

printf 'branch=%s\npath=%s\nworkspace=%s\npane=%s\n' "$branch" "$wt_path" "$ws" "$pane"

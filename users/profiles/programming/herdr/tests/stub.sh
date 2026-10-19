#!/bin/sh
set -eu
case "${0##*/}" in
  git)
    case "$*" in
      *--git-common-dir*) printf '%s/.git\n' "$TEST_REPO" ;;
      *symbolic-ref*) printf 'origin/main\n' ;;
      *show-ref*) exit 1 ;;
    esac
    ;;
  date)
    n=$(cat "$TEST_STATE/clock")
    printf '%s\n' "$((n + 1))" >"$TEST_STATE/clock"
    printf '%s\n' "$n"
    ;;
  sleep) : ;;
  herdr)
    case "$1 $2" in
      'worktree create') printf '{"result":{"workspace":{"workspace_id":"wTest"},"worktree":{"path":"/test/worktree"}}}\n' ;;
      'agent list') printf '{"result":{"agents":[{"workspace_id":"wTest","pane_id":"wTest:p1"}]}}\n' ;;
      'agent get')
        n=$(cat "$TEST_STATE/gets")
        n=$((n + 1))
        printf '%s\n' "$n" >"$TEST_STATE/gets"
        status=idle ready=true agent='"opencode"'
        case "$TEST_SCENARIO" in
          blocked) status=blocked ;;
          disappeared) agent=null ;;
          api-error) printf 'inspection failed\n' >&2; exit 1 ;;
          timeout) ready=false ;;
          delayed) if [ "$n" -eq 1 ]; then agent=null; ready=false; fi ;;
        esac
        pending=false
        [ "$TEST_SCENARIO" != delayed ] || pending=true
        printf '{"result":{"agent":{"workspace_id":"wTest","agent":%s,"agent_status":"%s","interactive_ready":%s,"launch_pending":%s}}}\n' "$agent" "$status" "$ready" "$pending"
        ;;
      'agent read')
        # Idle + interactive_ready may precede the actual mounted welcome UI.
        if [ "$TEST_SCENARIO" != delayed ] || [ "$(cat "$TEST_STATE/gets")" -ge 3 ]; then
          printf 'Ask anything…\ntab agents  ctrl+p commands\n'
        fi
        ;;
      'agent prompt')
        if [ "$TEST_SCENARIO" = delayed ]; then
          [ "$(cat "$TEST_STATE/gets")" -ge 3 ] || exit 99
        fi
        [ "$4" = "$(printf 'A multiline prompt\nwith a second line.')" ] || exit 98
        printf 'submitted\n' >>"$TEST_STATE/prompts"
        case "$TEST_SCENARIO" in
          stalled) printf '{"error":{"code":"agent_prompt_stalled"}}\n' >&2; exit 1 ;;
          rejected) printf '{"error":{"code":"agent_blocked"}}\n' >&2; exit 1 ;;
        esac
        ;;
      *) printf 'unexpected herdr call: %s\n' "$*" >&2; exit 97 ;;
    esac
    ;;
esac

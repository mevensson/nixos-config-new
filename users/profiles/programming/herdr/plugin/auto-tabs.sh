#!/bin/sh
set -eu

[ "${HERDR_PLUGIN_EVENT:-}" = "workspace.created" ] || exit 0

bin="${HERDR_BIN_PATH:?}"
ws="${HERDR_WORKSPACE_ID:-}"
[ -n "$ws" ] || exit 0

ctx="${HERDR_PLUGIN_CONTEXT_JSON:-}"
cwd=$(printf '%s' "$ctx" | jq -r '.workspace_cwd // empty')
[ -n "$cwd" ] || cwd="${HOME}"
tab=$(printf '%s' "$ctx" | jq -r '.tab_id // empty')
pane=$(printf '%s' "$ctx" | jq -r '.focused_pane_id // empty')

if [ -n "$tab" ] && [ -n "$pane" ]; then
  "$bin" tab rename "$tab" agent >/dev/null
  agent_pane="$pane"
else
  agent_tab=$("$bin" tab create --workspace "$ws" --cwd "$cwd" --label agent --no-focus)
  agent_pane=$(printf '%s' "$agent_tab" | jq -r '.result.root_pane.pane_id // empty')
fi

"$bin" tab create --workspace "$ws" --cwd "$cwd" --label git --no-focus >/dev/null

if [ -n "$agent_pane" ]; then
  "$bin" agent start "agent-${ws}" --kind opencode --pane "$agent_pane" >/dev/null 2>&1 || true
fi

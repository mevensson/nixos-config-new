#!/bin/sh
# Run with sh; uses real jq and replaces external mutations with fixtures.
set -eu
here=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
mkdir "$tmp/bin"
export TEST_STATE="$tmp" TEST_REPO="$tmp"
cp "$here/stub.sh" "$tmp/stub"
chmod +x "$tmp/stub"
for tool in git herdr date sleep; do
  ln -s "$tmp/stub" "$tmp/bin/$tool"
done
export PATH="$tmp/bin:$PATH"
for scenario in delayed timeout blocked disappeared api-error stalled rejected; do
  export TEST_SCENARIO="$scenario"
  printf '0\n' >"$tmp/clock"
  printf '0\n' >"$tmp/gets"
  : >"$tmp/prompts"
  result=0
  printf 'A multiline prompt\nwith a second line.\n' |
    sh "$here/../scripts/new-wt.sh" --slug test-delivery --cwd "$tmp" >"$tmp/output" 2>&1 || result=$?
  if [ "$scenario" = delayed ]; then
    [ "$result" -eq 0 ]
  else
    [ "$result" -ne 0 ]
  fi
  case "$scenario" in
    delayed|stalled|rejected) [ "$(wc -l <"$tmp/prompts")" -eq 1 ] ;;
    *) [ ! -s "$tmp/prompts" ]; grep -F 'prompt was not submitted' "$tmp/output" ;;
  esac
  case "$scenario" in
    stalled) grep -F 'inspect agent get/read before resending' "$tmp/output" ;;
    rejected) grep -F 'agent rejected prompt before submission' "$tmp/output" ;;
  esac
  for field in branch=worktree/test-delivery path= workspace=wTest pane=wTest:p1; do
    grep -F "$field" "$tmp/output" >/dev/null
  done
  printf 'PASS %s\n' "$scenario"
done

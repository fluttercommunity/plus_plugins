#!/usr/bin/env bash
set -euo pipefail
SCRIPT="$(cd "$(dirname "$0")" && pwd)/analyze-changed-packages.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/repo"
cat > "$work/bin/melos" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$MELOS_CALLS"
MOCK
chmod +x "$work/bin/melos"
export PATH="$work/bin:$PATH"
export MELOS_CALLS="$work/calls"
cd "$work/repo"
git init -q -b main
git config user.email test@example.com
git config user.name Test
mkdir -p packages/share_plus/share_plus packages/device_info_plus/device_info_plus
printf 'old\n' > packages/share_plus/share_plus/foo.dart
printf 'old\n' > packages/device_info_plus/device_info_plus/foo.dart
git add .
git commit -qm base
git remote add origin .
git fetch -q origin main
git checkout -q -b feature
export GITHUB_EVENT_NAME=pull_request GITHUB_BASE_REF=main

assert_calls() {
  local expected="$1"
  local actual="$(cat "$MELOS_CALLS" 2>/dev/null || true)"
  if [[ "$actual" != "$expected" ]]; then
    printf 'Expected: %s\nActual: %s\n' "$expected" "$actual" >&2
    exit 1
  fi
}

# A single plugin family is analyzed; unrelated packages are skipped.
printf 'new\n' > packages/share_plus/share_plus/foo.dart
git add . && git commit -qm single
: > "$MELOS_CALLS"
"$SCRIPT"
assert_calls 'exec -c 5 --scope=*share_plus* -- dart analyze . --fatal-infos'

# Two plugin families produce exactly two invocations, sorted, without repeats.
printf 'newer\n' > packages/share_plus/share_plus/foo.dart
printf 'new\n' > packages/device_info_plus/device_info_plus/foo.dart
git add . && git commit -qm multiple
: > "$MELOS_CALLS"
"$SCRIPT"
assert_calls $'exec -c 5 --scope=*device_info_plus* -- dart analyze . --fatal-infos\nexec -c 5 --scope=*share_plus* -- dart analyze . --fatal-infos'

# A workspace config change requires complete analysis.
printf 'config\n' > analysis_options.yaml
git add . && git commit -qm global
: > "$MELOS_CALLS"
"$SCRIPT"
assert_calls 'run analyze'

# The push path retains complete analysis.
: > "$MELOS_CALLS"
GITHUB_EVENT_NAME=push "$SCRIPT"
assert_calls 'run analyze'

# Missing base is an error and cannot quietly pass CI.
: > "$MELOS_CALLS"
if GITHUB_BASE_REF='' "$SCRIPT" 2>/dev/null; then
  echo 'Missing base incorrectly succeeded' >&2
  exit 1
fi
assert_calls ''

echo 'PASS: scoped analysis, multi-family, workspace changes, pushes, and missing base'

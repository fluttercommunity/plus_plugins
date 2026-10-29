#!/usr/bin/env bash
# Scope pull-request analysis to the affected plugin families. Pushes to main
# and changes outside packages/ still analyze the entire workspace.
set -euo pipefail

if [[ "${GITHUB_EVENT_NAME:-}" != "pull_request" ]]; then
  exec melos run analyze
fi

if [[ -z "${GITHUB_BASE_REF:-}" ]]; then
  echo 'GITHUB_BASE_REF is required for pull requests' >&2
  exit 1
fi

changed_files="$(git diff --name-only "origin/${GITHUB_BASE_REF}...HEAD")"
packages=()
while IFS= read -r file; do
  [[ -z "$file" ]] && continue
  case "$file" in
    packages/*/*)
      family="${file#packages/}"
      packages+=("${family%%/*}")
      ;;
    *)
      # Workspace configuration or CI changes may affect every package.
      echo "Workspace file changed: $file. Analyzing all packages."
      exec melos run analyze
      ;;
  esac
done <<< "$changed_files"

if (( ${#packages[@]} == 0 )); then
  echo 'No package changes to analyze.'
  exit 0
fi

# Analyze every package in the changed plugin families, including their
# platform interfaces and examples, to catch issues across package boundaries.
while IFS= read -r family; do
  [[ -z "$family" ]] && continue
  echo "Analyzing ${family} packages"
  melos exec -c 5 --scope="*${family}*" -- dart analyze . --fatal-infos
done < <(printf '%s\n' "${packages[@]}" | sort -u)

#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# This file is part of the xPack distribution.
#   (https://xpack.github.io)
# Copyright (c) 2021 Liviu Ionescu.
#
# Permission to use, copy, modify, and/or distribute this software 
# for any purpose is hereby granted, under the terms of the MIT license.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Safety settings (see https://gist.github.com/ilg-ul/383869cbb01f61a51c4d).

if [[ ! -z ${DEBUG} ]]
then
  set ${DEBUG} # Activate the expand mode if DEBUG is anything but empty.
else
  DEBUG=""
fi

set -o errexit # Exit if command failed.
set -o pipefail # Exit if pipe failed.
set -o nounset # Exit if variable not set.

# Remove the initial space and instead use '\n'.
IFS=$'\n\t'

# -----------------------------------------------------------------------------
# Identify the script location, to reach, for example, the helper scripts.

script_path="$0"
if [[ "${script_path}" != /* ]]
then
  # Make relative path absolute.
  script_path="$(pwd)/$0"
fi

script_name="$(basename "${script_path}")"

script_folder_path="$(dirname "${script_path}")"
script_folder_name="$(basename "${script_folder_path}")"

# =============================================================================

tmp_path=$(mktemp)
rm -rf "${tmp_path}"

# Note: __EOF__ is NOT quoted to allow substitutions.
cat <<__EOF__ > "${tmp_path}"
{
  "ref": "master", 
  "inputs": {
    "name": "Baburiba"
  }
}
__EOF__

echo
echo "Request body:"
cat "${tmp_path}"

# This script requires an authentication token in the environment.
# https://docs.github.com/en/rest/reference/actions#create-a-workflow-dispatch-event

echo
echo "Response:"

curl \
  --request POST \
  --include \
  --header "Authorization: token ${GITHUB_API_DISPATCH_TOKEN}" \
  --header "Content-Type: application/json" \
  --header "Accept: application/vnd.github.v3+json" \
  --data-binary @"${tmp_path}" \
  https://api.github.com/repos/ilg-ul/test-gh-actions/actions/workflows/docker-steps.yml/dispatches

rm -rf "${tmp_path}"


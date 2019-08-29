#!/usr/bin/env bash

# A variant of deno-install.sh that keeps versions separate and doesn't update the environment until welcome.ts is run.
# usage: deno-install-here.sh [<symbolic_link> [<version_tag>]]
# Usually you'll call this with no arguments to install the latest published deno in ${DENO_INSTALL}/current

set -e

function error {
    printf "$*\n"
    exit 1
}

# Installation defaults are relative to this file. DENO_INSTALL will override them.
me=$(realpath ${BASH_SOURCE})
# https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html
here=${me%/*}
current=${1:-current}
tag=${2}
folder=${tag:-latest}
DENO_INSTALL=${DENO_INSTALL:-${here}/${folder}}

[[ ! -d ${DENO_INSTALL} ]] || mkdir -pv ${DENO_INSTALL}  # deno.land install.sh has different defaults
printf "installing deno '${tag:-latest}' into '${DENO_INSTALL}'"
curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=${DENO_INSTALL} sh -s ${tag}
this_deno=${DENO_INSTALL}/bin/deno

welcome=https://deno.land/welcome.ts
${this_deno} ${welcome} || error "'${this_deno}' couldn't run '${welcome}' successfully."
this_version=$(${this_deno} --version | grep deno | cut -c7-)

if [[ ${folder} = latest ]] ; then
    # Renaming where deno is installed.
    DENO_INSTALL=${here}/deno-${this_version}
    # Set aside the old installation just in case.
    [[ -d ${DENO_INSTALL} ]] && mv -vf ${DENO_INSTALL}{,-$$}
    # Rename the installation location to include the deno version.
    mv -v ${here}/latest ${DENO_INSTALL}
fi

new_current=${here}/${current}
[[ -d ${new_current} ]] && unlink ${new_current}
ln --symbolic --relative --verbose --directory ${DENO_INSTALL} ${new_current}
printf "Update your environment with 'export DENO_INSTALL=${new_current}' (if needed).\n"

# Update your completions
this_deno=${new_current}/bin/deno
${this_deno} completions ${SHELL##*/} > ~/.config/bash_completion.d/deno-completions.bash

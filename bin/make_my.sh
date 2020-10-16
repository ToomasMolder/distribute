#!/bin/bash
###################################################################
# Script Name   : make_my.sh
# Script version: 1.1
# Script date   : 2020-10-16
# Description   : Make my environment handy
# Args          : <none>
# Author        : Toomas Mölder
# Email         : toomas.molder@gmail.com
###################################################################
## Make my bash environment handy
##
## Usage: make_my.sh [options]
##
## Options:
##   -h, --help    Display this message.
##   -v, --version Display version.
##   -x, --xtrace  Print a trace of commands and their arguments
##                 before they are executed.
##

function usage() {
  [ "$*" ] && echo "$0: $*"
  sed -n '/^## /,/^$/s/^## \{0,1\}//p' "$0"
  exit $?
} 2>/dev/null

function version() {
  [ "$*" ] && echo "$0: Version "
  printf "$0: version "; grep "^# Script version: " ${0} | awk -F: '{print $2}' | sed -e 's/^[[:space:]]*//'
  exit $?
} 2>/dev/null

function update() {
  #
  # echo "Check parameters and files available"
  #
  if [ $# -ne 2 ]; then echo "${0}: Warning: function ${FUNCNAME}() MUST have EXACTLY two parameters. Do nothing."; return; fi
  from="${1}"; to="${2}"
  if [ ! -s "${from}" ]; then echo "${0}: Warning: file ${from} does not exist or is empty. Do nothing."; return; fi
  #
  # echo "Get version and date"
  #
  FROM_VERSION=$(egrep --no-messages "^[#\"] Script version *: " ${from} | tail --lines 1 | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//' | bc -l)
  FROM_DATE=$(grep --no-messages "^[#\"] Script date *: " ${from} | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//')
  # echo "${from}: version: ${FROM_VERSION} (${FROM_DATE})"
  TO_VERSION=$(egrep --no-messages "^[#\"] Script version *: " ${to} | tail --lines 1 | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//' | bc -l)
  TO_DATE=$(grep --no-messages "^[#\"] Script date *: " ${to} | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//')
  # echo "${to}: version: ${TO_VERSION} (${TO_DATE})"
  #
  # echo "Remove all new line, carriage return, tab characters"
  # echo "from the string, to allow integer / float comparison."
  FROM_VERSION="${FROM_VERSION//[$'\t\r\n ']}"
  FROM_DATE="${FROM_DATE//[$'\t\r\n ']}"
  TO_VERSION="${TO_VERSION//[$'\t\r\n ']}"
  TO_DATE="${TO_DATE//[$'\t\r\n ']}"
  # echo "${from}: version: ${FROM_VERSION} (${FROM_DATE})"
  # echo "${to}: version: ${TO_VERSION} (${TO_DATE})"

  #
  # echo "Check existence. If not, then give default value."
  if [ -z "${FROM_VERSION}" ]; then FROM_VERSION=0.0; fi
  if [ -z "${FROM_DATE}" ]; then FROM_DATE=1970-01-01; fi
  if [ -z "${TO_VERSION}" ]; then TO_VERSION=0.0; fi
  if [ -z "${TO_DATE}" ]; then TO_DATE=1970-01-01; fi
  # echo "${from}: version: ${FROM_VERSION} (${FROM_DATE})"
  # echo "${to}: version: ${TO_VERSION} (${TO_DATE})"

  #
  # echo "Make update happen only when newest version is not yet present."
  # TODO: remove previous version from ${to} if exists, to avoid duplicate handys ...
  # smth like sed -n '/^###################################################################/,$ p' ${to} -i.bak
  #
  printf "${to}"
  if (( $(echo "${TO_VERSION} < ${FROM_VERSION}" | bc -l) || $(echo "${TO_DATE} < ${FROM_DATE}" | bc -l))); then
    if [ -f ${to} ]; then /bin/cp --preserve ${to} ${to}.bak; fi
    /bin/cat ${from} >> ${to};
    echo " updated from version ${TO_VERSION} (${TO_DATE}) to version ${FROM_VERSION} (${FROM_DATE})."
  else
    echo " version ${TO_VERSION} (${TO_DATE}) already exists. Did not update."
  fi
}

function main() {
  # echo "Check xtrace."
  if [ "${XTRACE}" == "y" ]; then set -o xtrace; fi

  # echo "Check script version and date. Make update happen only when newest version is not yet present."
  SCRIPT_VERSION=$(grep --no-messages "^# Script version *: " ${0} | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//' | bc -l)
  SCRIPT_DATE=$(grep --no-messages "^# Script date *: " ${0} | awk -F: '{print $2}' | awk '{print $1}' | sed -e 's/^[[:space:]]*//')
  # echo "${0} version: ${SCRIPT_VERSION} (${SCRIPT_DATE})"

  update ${LOCALREPO}/.my_profile ${HOME}/.profile
  update ${LOCALREPO}/.my_bashrc ${HOME}/.bashrc
  update ${LOCALREPO}/.my_bash_aliases ${HOME}/.bash_aliases
  update ${LOCALREPO}/.my_vimrc ${HOME}/.vimrc
  update ${LOCALREPO}/.my_screenrc ${HOME}/.screenrc

  # update ${HOME}/.config/htop/htoprc
  # Beware! This file is rewritten by htop when settings are changed in the interface.
  # The parser is also very primitive, and not human-friendly.
  # color_scheme=
  # Default = 0
  # Monochromatic = 1
  # Black on White = 2
  # Light Terminal = 3
  # MC = 4
  # Black Night = 5
  # Broken Gray = 6
  # I like Broken Gray, ie color_scheme=6
  sed --in-place=.bak --expression 's/^color_scheme=.*$/color_scheme=6/' ${HOME}/.config/htop/htoprc

  exit $?
}

#
# MAIN
#

REPO="make-me-handy"
LOCALREPO="${HOME}/${REPO}"

while [ $# -gt 0 ]; do
  case $1 in
  (-h|--help) usage 2>&1;;
  (-v|--version) version 2>&1;;
  (-x|--xtrace) XTRACE="y"; set -o xtrace; shift;;
  (--) shift; break;;
  (-*) usage "$1: unknown option"; exit;;
  (*) break;;
  esac
done

# Do the main stuff
main
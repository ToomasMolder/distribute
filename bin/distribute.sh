#!/bin/bash
###################################################################
# Script Name   : distribute.sh
# Script version: 1.2
# Script date   : 2021-01-17
# Description   : Distribute my settings and management scripts
#               : throughout my servers
# Author        : Toomas Mölder
# Email         : toomas.molder@gmail.com
###################################################################

# SOURCE=$(eval echo "~")
SOURCE="${HOME}"

# We assume the script itself to be distributed as well
MYSELF="${0}"

# Set up list of files to be distributed
DOTFILES="${SOURCE}/.profile ${SOURCE}/.bashrc ${SOURCE}/.bash_aliases ${SOURCE}/.vimrc ${SOURCE}/.screenrc"
HTOPRC="${HOME}/.config/htop/htoprc"

# Set up list of management scripts to be distributed
BINFILES="${SOURCE}/bin/colours.sh ${SOURCE}/bin/highlight.sh ${SOURCE}/bin/update.sh ${SOURCE}/bin/make_my.sh"

# Set up space-delimited list of my project servers, short host names, without DNS domain name
DESTINATIONS=""

# Current host
MY_HOSTNAME=$(hostname --short)

# DNS domain name
DOMAIN=$(hostname --domain)

CWD=$(pwd)

# Set up public/private keys to distribute
id_rsa=false

if [ ! -f "${HOME}/.ssh/id_rsa.pub" ] || [ ! -f "${HOME}/.ssh/id_rsa" ]; then
    # echo "No public/private key pair available, generate ..."
    ssh-keygen
fi

if [ -f "${HOME}/.ssh/id_rsa.pub" ] && [ -f "${HOME}/.ssh/id_rsa" ]; then
    # echo "Public/private key pair exists, set temporary variable"
    id_rsa=true
fi

# Distribute
for destination in $(echo ${DESTINATIONS}); do
    if [ "${destination}" != "${MY_HOSTNAME}" ]
        then
        destination="${destination}.${DOMAIN}"
        echo "=== ${destination} ==="
        if [ "${id_rsa}" == true ]; then
            # echo "Just in case we try to distribute public key as well"
            ssh-copy-id ${LOGNAME}@${destination}
        else
            # echo "Hmmm, no public/private key pair available. Be prepared to enter your password ..."
            : # no-op
        fi
        # DOTFILES
        scp -p ${DOTFILES} ${destination}:
        # HTOPRC
        ssh ${destination} "mkdir --parents .config/htop/"
        scp -p ${HTOPRC} ${destination}:.config/htop/
        # BINFILES
        ssh ${destination} "mkdir --parents bin/"
        scp -p ${MYSELF} ${BINFILES} ${destination}:bin/
    fi
done

cd ${CWD}
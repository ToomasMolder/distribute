#!/bin/bash

SOURCE=$(eval echo "~")
# echo "SOURCE = ${SOURCE}"

# We assume the script itself to be distributed as well into ${HOME}/bin
# MYSELF="${SOURCE}/bin/distribute.sh"
MYSELF="${0}"

# Set up list of files to be distributed into ${HOME}
DOTFILES="${SOURCE}/.bash_aliases ${SOURCE}/.profile ${SOURCE}/.screenrc"

# Set up list of management scripts to be distributed into ${HOME}/bin
BINFILES="${SOURCE}/bin/colors.sh ${SOURCE}/bin/highlight.sh"

# Set up space-delimited list of my servers
DESTINATIONS=""

HOSTNAME=$(hostname -f)

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
    if [ "${destination}" != "${HOSTNAME}" ]
        then
        echo "=== ${destination} ==="
        if [ "${id_rsa}" == true ]; then
            # echo "Just in case we try to distribute public key as well"
            ssh-copy-id ${LOGNAME}@${destination}
        else
            # echo "Hmmm, no public/private key pair available. Be prepared to enter your password ..."
            : # no-op
        fi
        scp -p ${DOTFILES} ${destination}:
        ssh ${destination} "mkdir --parents bin/"
        scp -p ${MYSELF} ${BINFILES} ${destination}:bin/
    fi
done

cd ${CWD}

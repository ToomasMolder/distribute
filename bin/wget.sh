#!/bin/bash
###################################################################
# Script Name   : wget.sh
# Script version: 1.0
# Script date   : 2020-10-06
# Description   : Download entire website into local
# Args          : <none>
# Author        : Toomas Mölder
# Email         : toomas.molder@gmail.com
###################################################################

usage() {
    echo "Usage: ${0}"
    exit 0
    }
    
usage_urls() {
    echo "Usage: ${0}"
    echo "Please fill parameter URLS within script beforehand!"
    exit 0
    }

user-agent="toomasm"
exclude-domains="plumbr.ria.ee"

CWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# -E --adjust-extension
# -H --span-hosts
WGET_PARAMS="--recursive --level=2 --page-requisites --span-hosts"
if test -n "${user-agent}"
then
    WGET_PARAMS="${WGET_PARAMS} --user-agent='${user-agent}'"
fi
if test -n "${exclude-domains}"
then
    WGET_PARAMS="${WGET_PARAMS} --exclude-domains ${exclude-domains}"
fi

# Space delimited URLs
URLS=""
if test -z "${URLS+x}"
then
    usage_urls
fi

echo $(date "+[%F %T]") ===== Start ${0} ... ===== | tee -a ${DIR}/${0}.log

for url in $(echo ${URLS})
do
    url_snipped=$(echo ${url} | sed -e "s/https:\/\///g" | sed -e "s/http:\/\///g" | sed -e "s/:/_/g" | sed -e "s/\//_/g" | sed -e "s/_$//")
    # echo ${url_snipped}
    url_log=$(echo ${url_snipped} | sed -e "s/$/\.log/")
    # echo ${url_log}
    header_log=$(echo ${url_snipped} | sed -e "s/$/\.header/")
    # echo ${header_log}
    echo $(date "+[%F %T]") ${url} | tee -a  ${DIR}/${0}.log
    wget ${WGET_PARAMS} --output-file=${DIR}/${url_log} ${url}
    echo "Logfile of ${url}: ${DIR}/${url_log}"
done

echo $(date "+[%F %T]") ===== End of ${0} ===== | tee -a ${DIR}/${0}.log
echo "Logfile: ${DIR}/${0}.log"
cd ${CWD}

# Aliases for toomasm
#
# Copy from ~/.bashrc
# Instead of auto use always
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='/bin/ls --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=always'
    alias fgrep='fgrep --color=always'
    alias egrep='egrep --color=always'
fi

alias a=alias
alias cc='/usr/bin/clear'
alias dfh='/bin/df -h'
alias h=history
alias hgrep='history | /bin/egrep -i $1'
alias lart='/bin/ls -alrt'
alias less='/bin/less -R'
alias ll='/bin/ls -l'
alias lrt='/bin/ls -lrt'
alias rm='/bin/rm -i'
alias rmf='/bin/rm'
alias sr='/usr/bin/screen -r'
alias tf='/usr/bin/tail -f'
# alias update='sudo apt-get update; sudo apt-get dist-upgrade; sudo apt-get autoremove; read -p "Press any key to continue... " -n1 -s; echo; cat /var/run/reboot-required; cat /var/run/reboot-required.pkgs'
# alias update_y='sudo apt-get --assume-yes update; sudo apt-get --assume-yes dist-upgrade; sudo apt-get --assume-yes autoremove; read -p "Press any key to continue... " -n1 -s; echo; cat /var/run/reboot-required; cat /var/run/reboot-required.pkgs'

#
# Convert epoch date into human readable format
#
epoch () {
    /bin/date --date=@$1
}

#
# Find file from current point in directory tree
#
ff () {
        find . -printf "%TY-%Tm-%Td\t%s\t%p\n" | grep $1
}
#
# Find string within files from current point in directory tree
#
fsf () {
        # find . -type f -print0 | xargs -I {} -0 grep $1 "{}"
        find . -iname "*" -type f -print0  |  xargs -0 grep -H $1
}
#
# Find string within files from current point up to /
#
dnif () {
    # Recursively list a file from PWD up the directory tree to root
    [[ -n $1 ]] || { echo "dnif [ls-opts] name"; return 1; }
    local THERE=$PWD RC=2
    while [[ $THERE != / ]]
        do [[ -e $THERE/${2:-$1} ]] && { ls ${2:+$1} $THERE/${2:-$1}; RC=0; }
            THERE=$(dirname $THERE)
        done
    [[ -e $THERE/${2:-$1} ]] && { ls ${2:+$1} /${2:-$1}; RC=0; }
    return $RC
}

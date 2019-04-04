#!/bin/bash

FILE=~/.bmarks

GRAY='\e[1;30m'
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
RESET='\e[0m'

if [ ! -f $FILE ]; then
    touch $FILE
fi

function save {
    __help $1
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    else
        if grep -q "^$1|" $FILE; then
            echo -ne "${RED}bookmark \"$1\" already exists, overwrite?${RESET} "
            read REPLY
            if [[ "${REPLY,,}" == "yes" || "${REPLY,,}" == "y" ]]; then
                del $1 &> /dev/null
            else
                kill -INT $$
            fi
        fi
        echo "$1|$PWD" >> $FILE
        echo -e "${GREEN}bookmark for $PWD saved as \"$1\"${RESET}"
    fi
}

function jump {
    __help $1
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    else
        MARK=$(grep "^$1|" $FILE)
        if [[ -z $MARK ]]; then
            echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
        else
            cd $(echo "$MARK|" | cut -d\| -f2)
        fi
    fi
}

function list {
    __help $1
    if [ -s $FILE ]; then
        cat $FILE | sort | awk '{ printf "\033[1;33m%-18s\033[0m %s\n", $1, $2}' FS=\|
    else
        echo -e "${YELLOW}no bookmarks saved${RESET}"
    fi
}

function del {
    __help $1
    MARK=$(grep "^$1|" $FILE)
    if [[ -z $MARK ]]; then
        echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
    else
        \grep -v "^$1|" $FILE > $FILE.tmp
        \mv $FILE.tmp $FILE
        echo -e "${GREEN}deleted bookmark \"$1\"${RESET}"
    fi
}

function rename {
	__help $1
	MARK=$(grep "^$1|" $FILE)
	if [[ -z $1 ]]; then
		echo -e "${RED}no bookmark name provided${RESET}"
	elif [[ -z $2 ]]; then
		echo -e "${RED}no new bookmark name provided${RESET}"
	elif [[ -z $MARK ]]; then
		echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
	fi

	DIR=$(echo $MARK | cut -d\| -f2)
	CURDIR=$(pwd)
	del $1 &> /dev/null &&

	cd $DIR
	save &> /dev/null $2
	cd $CURDIR

	echo -e "${GREEN}bookmark \"$1\" renamed to \"$2\"${RESET}"
}

function __help {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo -e "${BLUE}────────────── bashMarks ──────────────${RESET}
save ${GRAY}<name>${RESET}                    save current directory
jump ${GRAY}<name>${RESET}                    jump to a bookmark
del  ${GRAY}<name>${RESET}                    delete a bookmark
list                           list all bookmarks
rename ${GRAY}<oldname> <newname>${RESET}     rename a bookmark"
        kill -INT $$
    fi
}

alias s='save'
alias j='jump'
alias d='del'
alias l='list'
alias r='rename'

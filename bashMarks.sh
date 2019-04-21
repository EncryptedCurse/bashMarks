#!/bin/bash
FILE=~/.bmarks

alias s='save'
alias j='jump'
alias b='back'
alias d='del'
alias r='ren'
alias l='list'

GRAY='\e[1;30m'
RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
RESET='\e[0m'

if [[ ! -f $FILE ]]; then
    touch $FILE
fi

function save {
    __help $1
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    elif [[ -n $2 ]]; then
        if [[ -d $2 ]]; then
            __overwrite $1
            echo "$1|$2" >> $FILE
            echo -e "${GREEN}bookmark for $2 saved as \"$1\"${RESET}"
        else
            echo -e "${RED}directory $2 does not exist${RESET}"
        fi
    else
        __overwrite $1
        echo "$1|$PWD" >> $FILE
        echo -e "${GREEN}bookmark for $PWD saved as \"$1\"${RESET}"
    fi
}

function jump {
    __help $1
    local MARK=$(grep "^$1|" $FILE)
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    elif [[ -z $MARK ]]; then
        echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
    else
        export __LAST=$PWD
        cd $(echo "$MARK" | cut -d\| -f2)
    fi
}

function back {
    __help $1
    if [[ -z $__LAST ]]; then
        echo -e "${RED}no directory to jump back to${RESET}"
    else
        cd $__LAST
    fi
}

function del {
    __help $1
    local MARK=$(grep "^$1|" $FILE)
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    elif [[ -z $MARK ]]; then
        echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
    else
        \grep -v "^$1|" $FILE > $FILE.tmp
        \mv $FILE.tmp $FILE
        echo -e "${GREEN}deleted bookmark \"$1\"${RESET}"
    fi
}

function ren {
    __help $1
    local OLD_MARK=$(grep "^$1|" $FILE)
    local NEW_MARK=$(grep "^$2|" $FILE)
    if [[ -z $1 ]]; then
        echo -e "${RED}no bookmark name provided${RESET}"
    elif [[ -z $2 ]]; then
        echo -e "${RED}you did not specify a new bookmark name${RESET}"
    elif [[ $1 == $2 ]]; then
        echo -e "${RED}choose a new bookmark name${RESET}"
    elif [[ -z $OLD_MARK ]]; then
        echo -e "${RED}bookmark \"$1\" does not exist${RESET}"
    elif [[ -n $NEW_MARK ]]; then
        echo -e "${RED}boomark \"$2\" already exists${RESET}"
    else
        sed -i "s|^$1\||$2\||g" $FILE
        echo -e "${GREEN}renamed \"$1\" to \"$2\"${RESET}"
    fi
}

function list {
    __help $1
    if [[ -s $FILE ]]; then
        cat $FILE | sort | awk '{ printf "\033[1;34m%-18s\033[0m %s\n", $1, $2}' FS=\|
    else
        echo -e "${YELLOW}no bookmarks saved${RESET}"
    fi
}

function __help {
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo -e "${BLUE}───────────────── bashMarks ─────────────────${RESET}
save ${GRAY}<name> [dir]${RESET}   save current directory
jump ${GRAY}<name>${RESET}         go to bookmark
back                go to last directory
del  ${GRAY}<name>${RESET}         delete bookmark
ren  ${GRAY}<old> <new>${RESET}    rename bookmark
list                list all bookmarks"
        kill -INT $$
    fi
}

function __overwrite {
    if grep -q "^$1|" $FILE; then
        echo -ne "${RED}bookmark \"$1\" already exists, overwrite?${RESET} "
        local REPLY; read REPLY
        if [[ "${REPLY,,}" == "yes" || "${REPLY,,}" == "y" ]]; then
            del $1 &> /dev/null
        else
            kill -INT $$
        fi
    fi
}

function __autocomp {
    local CUR=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '$(cut -d\| -f1 $FILE)' -- $CUR))
    return 0
}

complete -F __autocomp jump
complete -F __autocomp del
complete -F __autocomp ren
complete -F __autocomp j
complete -F __autocomp d
complete -F __autocomp r

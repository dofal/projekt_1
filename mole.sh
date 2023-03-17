#!/bin/sh
# xdofek02 Jiří Dofek
# 12.03.2023

#####
### Setup
#####

export POSIXLY_CORRECT=yes
export LC_ALL=C

#####
### Script started, let's get user info to secret-log
#####

date=$(date)
user=$(whoami)

#####
### Functions
#####

# Mole_Help - printing help to user
mole_help (){
    echo "\n##### Nápověda mole: #####\n"
    echo "#1 $ mole [-g GROUP] FILE ==> Zadaný soubor bude otevřen. Pokud byl zadán přepínač -g, dané otevření souboru bude zároveň přiřazeno do skupiny s názvem GROUP. GROUP může být název jak existující, tak nové skupiny. \n"
    echo "#2 $ mole [-m] [FILTERS] [DIRECTORY] ==> Pokud DIRECTORY odpovídá existujícímu adresáři, skript z daného adresáře vybere soubor, který má být otevřen.\n"
    echo "#3 $ mole list [FILTERS] [DIRECTORY] ==> Skript zobrazí seznam souborů, které byly v daném adresáři otevřeny (editovány) pomocí skriptu.\n"
}
open_random(){
    file=($(ls | shuf))
    nano "$file"
    
}

#####
### Now we have informations about user, let's provide him exprected program - at first let's find out, how many arguments he passed.
#####

# User passed 0 arguments
if [ $# == 0 ]; then
    open_random
    echo "0 arguments"
# User passed at least 1 argument
else
    # User passed -H argument - let's provide him help
    x=0
    while [ $x -le $# ]
    do
        echo "loop $x times"
        case "$1" in
            -h)
                mole_help
                ;;
            list)
                echo "list"
                shift
                ;;
            secret-log)
                echo "secret-log"
                shift
                ;;
        esac
        x=$(( $x + 1 ))
    done
fi
echo "testing output: date:$date, user:$user"

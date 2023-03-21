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

# Open_Random - mole with no arguments - open random file in directory
open_random(){
    # get name of random file in folder - without directory names
    file=($(ls -p | grep -v / | shuf -n 1))
    # directory is not empty - $file is not empty - open random file
    if [ ! -z "$file" ]; then
        file_name="$file"
        nano "$file"
    # directory is empty - $file is empty string - nothing to open
    else
        echo "There are no files in this folder. Try mole -h for help."
    fi
}
mole_rc_init(){
    # MOLE_RC doesn't exist - let's create
    if [ ! -f "MOLE_RC" ]; then
        touch MOLE_RC
    fi
}
mole_rc_check(){
    # MOLE_RC doesn't exist - let's create
    if [ ! -f "MOLE_RC" ]; then
        echo "There is nothing to list in this folder. Nothing was opened or edited."
    fi
}
append_log(){
    echo "$date | $user | $file_name;" >> MOLE_RC
}

#####
### Now we have informations about user, let's provide him exprected program - at first let's find out, how many arguments he passed.
#####

# User passed 0 arguments
if [ $# == 0 ]; then
    # Open random file in current folder
    open_random
    mole_rc_init
    append_log
# User passed at least 1 argument
else
    x=1 #loop count
    while [ $x -le $# ]
    do
        case "$1" in
            # User passed -H argument - let's provide him help
            -h)
                mole_help
                ;;
            list) #todo
                shift
                if [ -d "$1" ]; then
                    directory=$1
                    cd $directory
                fi
                mole_rc_check
                while read p; do
                    echo "$p"
                done <MOLE_RC
                ;;
            secret-log) # todo
                echo "secret-log"
                shift
                ;;
            -g)
                shift
                group=$1
                echo "$group"
                shift
                if [ -f "$1" ]; then
                    nano "$1"
                    file_name="$1"
                    mole_rc_init
                    append_log
                else 
                    echo "File doesn't exist. Try again or type mole -h for help."
                fi

                ;;
            # Check if argument is file 
            *)
                if [ -f "$1" ]; then
                    nano "$1"
                    file_name="$1"
                    mole_rc_init
                    append_log
                fi
                if [ -d "$1" ]; then
                    directory=$1
                    cd $directory
                    open_random
                    mole_rc_init
                    append_log
                fi                
        esac
        # loop count +1
        x=$(( $x + 1 ))
    done
fi

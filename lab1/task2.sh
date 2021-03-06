#!/bin/bash

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage ./task2.sh";
    echo "Script installs task1.sh as executable and adds it in PATH";
    exit 0;
fi

check_directory() {
    if [ ! -d $1 ]; then
        echo "Directory was not found and will be automatically created."
        mkdir -p "$1" 2>&1
    fi
    if [ $? -ne 0 ]; then
        if [[ $LANG =~ uk_UA ]]; then
            echo "Директорію не було створено" 1>&2
        else
            echo "Error creating directory" 1>&2
        fi
        exit 1
    fi
}

add_to_path() {
    echo "export PATH="\$HOME/bin:\$PATH"" >> $HOME/.bash_profile
}

create_backup() {
    cur_d=$(date "+%Y%m%d")
    bash_profile_num_found_files=$(ls -lav $HOME | grep -E ".bash_profile" | wc -l)
    bash_profile_new_number=$(expr "$bash_profile_num_found_files" + 1)
    bash_profile_new_number_formatted="$(printf "%04d" $bash_profile_new_number)"
    new_bash_profile=".bash_profile-${cur_d}-${bash_profile_new_number_formatted}"
    cp $HOME/.bash_profile $HOME/${new_bash_profile}


    bash_rc_num_found_files=$(ls -lav $HOME | grep -E ".bashrc" | wc -l)
    bash_rc_new_number=$(expr "$bash_rc_num_found_files" + 1)
    bash_rc_new_number_formatted="$(printf "%04d" $bash_rc_new_number)"
    new_bash_rc=".bashrc-${cur_d}-${bash_rc_new_number_formatted}"
    cp $HOME/.bashrc $HOME/${new_bash_rc}
}

change_permissions() {
    chmod 755 $HOME/bin/task1.sh
}


install() {
    check_directory "$HOME/bin"
    cp task1.sh "$HOME/bin"
    create_backup
    add_to_path 
    change_permissions
}

install

#!/bin/bash

# This script will create three users and add them to a group.

# Function to create a user
create_user() {
    user=$1
    if id "$user" &>/dev/null; then
        echo "User $user already exists."
    else
        echo SUDO_PASSWORD | sudo -S useradd $user
        echo "User $user created."
    fi
}

# Function to create a group and add users to it
create_group_and_add_users() {
    group=$1
    shift
    users=$@
    if getent group $group >/dev/null; then
        echo "Group $group already exists."
    else
        echo SUDO_PASSWORD | sudo -S groupadd $group
        echo "Group $group created."
    fi

    for user in $users; do
        echo SUDO_PASSWORD | sudo -S usermod -a -G $group $user
        echo "Added $user to $group."
    done
}

# Creating users
create_user "Dev"
create_user "Test"
create_user "Prod"

# Creating group and adding users
create_group_and_add_users "NginxG" "Dev" "Test" "Prod"

echo "Script execution completed."

#!/bin/bash

# Script to retrieve and list all users in the 'NginxG' group

group_name="NginxG"

# Retrieve group information using getent
group_info=$(getent group $group_name)

if [ -z "$group_info" ]; then
    echo "Group '$group_name' does not exist."
    exit 1
fi

# Extract the user list part from the group information
# The format of group_info is 'group_name:x:group_id:user_list'
user_list=$(echo $group_info | cut -d: -f4)

if [ -z "$user_list" ]; then
    echo "No users are in the '$group_name' group."
else
    echo "Users in the '$group_name' group:"
    # Print each user on a new line
    echo $user_list | tr ',' '\n'
fi

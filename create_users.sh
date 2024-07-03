#!/bin/bash

# Log file location
LOG_FILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure the log and password files exist and have appropriate permissions
touch "$LOG_FILE"
touch "$PASSWORD_FILE"
chmod 600 "$PASSWORD_FILE"

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Function to generate a random password
generate_password() {
    openssl rand -base64 12
}

# Ensure the script is run with a filename argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <name-of-text-file>"
    exit 1
fi

# Read the input file
INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
    echo "File not found: $INPUT_FILE"
    exit 1
fi

# Process each line of the input file
while IFS=';' read -r username groups; do
    username=$(echo "$username" | xargs) # Remove leading/trailing whitespace
    groups=$(echo "$groups" | xargs)     # Remove leading/trailing whitespace

    # Create a personal group for the user
    if ! getent group "$username" > /dev/null 2>&1; then
        groupadd "$username"
        log_message "Group '$username' created."
    else
        log_message "Group '$username' already exists."
    fi

    # Create the user if they don't exist
    if ! id -u "$username" > /dev/null 2>&1; then
        useradd -m -g "$username" -s /bin/bash "$username"
        log_message "User '$username' created."
    else
        log_message "User '$username' already exists."
    fi

    # Process additional groups
    IFS=',' read -r -a group_array <<< "$groups"
    for group in "${group_array[@]}"; do
        group=$(echo "$group" | xargs) # Remove leading/trailing whitespace
        if ! getent group "$group" > /dev/null 2>&1; then
            groupadd "$group"
            log_message "Group '$group' created."
        fi
        usermod -aG "$group" "$username"
        log_message "User '$username' added to group '$group'."
    done

    # Generate a random password and set it for the user
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    log_message "Password set for user '$username'."

    # Store the username and password securely
    echo "$username,$password" >> "$PASSWORD_FILE"

done < "$INPUT_FILE"

log_message "User creation and group assignment completed."

# Set secure permissions for the password file
chmod 600 "$PASSWORD_FILE"

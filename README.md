
# User and Group Management Script

This bash script automates the creation of users and groups on a Linux system based on an input text file. It also handles password generation, home directory setup, and logging of all actions.

## Features

- **User and Group Creation:** Automatically creates users and their personal groups. Assigns users to additional groups as specified.
- **Random Password Generation:** Generates a random password for each user and securely stores it.
- **Logging:** Logs all actions, including user creation, group assignments, and password settings.
- **Secure Password Storage:** Stores generated passwords securely in a specified file with restricted permissions.

## Prerequisites

- Ensure you have the necessary permissions to run user and group management commands (e.g., running the script as root or with sudo).
- `openssl` must be installed on your system for password generation.

## Usage

1. **Prepare the Input File:**

   - Create a text file where each line contains a username and a semicolon-separated list of groups.
   - Example:
     ```
     john;admin,developers
     jane;developers
     ```

2. **Run the Script:**

   - Execute the script by passing the input file as an argument:
     ```bash
     ./user_management.sh <name-of-text-file>
     ```

   - Example:
     ```bash
     ./user_management.sh users.txt
     ```

## Log and Password File Locations

- **Log File:** `/var/log/user_management.log` - Contains logs of all actions performed by the script.
- **Password File:** `/var/secure/user_passwords.txt` - Stores generated usernames and passwords securely. The file has restricted permissions to protect sensitive data.

## Example

Given an input file `users.txt` with the following content:

```plaintext
alice;developers,admin
bob;designers
```

Running the script as follows:

```bash
sudo ./user_management.sh users.txt
```

Would result in:

- The creation of users `alice` and `bob`.
- `alice` being added to the `developers` and `admin` groups.
- `bob` being added to the `designers` group.
- Random passwords generated for `alice` and `bob` stored securely in `/var/secure/user_passwords.txt`.
- A log of all these actions saved in `/var/log/user_management.log`.

## Security Considerations

- The password file is stored with permissions set to `600` to ensure it is only readable and writable by the root user.
- Ensure that the script and password file are handled securely, especially in multi-user environments.

## License

This script is released under the MIT License. See the [LICENSE](LICENSE) file for details.

---

This `README.md` provides clear instructions and details about the script's functionality, usage, and security considerations.

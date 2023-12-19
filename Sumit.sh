#!/bin/bash

# internsctl - Custom Linux Command
# Version: v0.1.0

# Function to display manual page
display_manual() {
  cat <<EOF
internsctl - Custom Linux Command

DESCRIPTION:
  A custom Linux command for specific operations.

USAGE:
  internsctl [COMMAND] [OPTIONS]

COMMANDS:
  cpu getinfo      Display CPU information.
  memory getinfo   Display memory information.
  user create      Create a new user.
  user list        List all regular users.
  user list --sudo-only  List users with sudo permissions.
  file getinfo [OPTIONS] <file-name>   Get information about a file.

OPTIONS:
  --size, -s           Print file size.
  --permissions, -p   Print file permissions.
  --owner, -o          Print file owner.
  --last-modified, -m  Print last modified time.

EXAMPLES:
  internsctl cpu getinfo
  internsctl memory getinfo
  internsctl user create <username>
  internsctl user list
  internsctl user list --sudo-only
  internsctl file getinfo hello.txt
  internsctl file getinfo --size hello.txt
  internsctl file getinfo --permissions hello.txt
  internsctl file getinfo --owner hello.txt
  internsctl file getinfo --last-modified hello.txt
EOF
}

# Function to display version
display_version() {
  echo "internsctl v0.1.0"
}

# Main script logic
case "$1" in
  --help)
    display_manual
    ;;
  --version)
    display_version
    ;;
  cpu)
    case "$2" in
      getinfo)
        lscpu
        ;;
      *)
        echo "Invalid CPU command. Use: internsctl cpu getinfo"
        ;;
    esac
    ;;
  memory)
    case "$2" in
      getinfo)
        free -h
        ;;
      *)
        echo "Invalid Memory command. Use: internsctl memory getinfo"
        ;;
    esac
    ;;
  user)
    case "$2" in
      create)
        if [ -z "$3" ]; then
          echo "Please provide a username."
        else
          sudo adduser "$3"
        fi
        ;;
      list)
        if [ "$3" == "--sudo-only" ]; then
          getent passwd | cut -d: -f1 | sudo xargs groups | grep -E '\bsudo\b' | cut -d: -f1
        else
          cut -d: -f1 /etc/passwd
        fi
        ;;
      *)
        echo "Invalid User command. Use: internsctl user create <username>"
        ;;
    esac
    ;;
  file)
    case "$2" in
      getinfo)
        file_name="$3"
        shift 3
        while [ "$#" -gt 0 ]; do
          case "$1" in
            --size | -s)
              du -h "$file_name" | cut -f1
              ;;
            --permissions | -p)
              ls -l "$file_name" | awk '{print $1}'
              ;;
            --owner | -o)
              stat -c %U "$file_name"
              ;;
            --last-modified | -m)
              stat -c %y "$file_name"
              ;;
            *)
              echo "Invalid option: $1"
              exit 1
              ;;
          esac
          shift
        done
        ;;
      *)
        echo "Invalid File command. Use: internsctl file getinfo [OPTIONS] <file-name>"
        ;;
    esac
    ;;
  *)
    echo "Invalid command. See 'internsctl --help' for usage."
    ;;
esac

#!/bin/bash
set -e

# Create 4 user accounts with local mailboxes if they don't exist
USERS=("user1" "user2" "user3" "user4")
PASSWORDS=("Pass123!" "Pass123!" "Pass123!" "Pass123!")

for i in "${!USERS[@]}"; do
  u="${USERS[$i]}"
  p="${PASSWORDS[$i]}"
  if ! id "$u" &>/dev/null; then
    useradd -m -s /sbin/nologin "$u"
    echo "$u:$p" | chpasswd
  fi
done

# Initialize aliases and directories
newaliases
postfix set-permissions || true

# Execute postfix in foreground
exec postfix start-fg

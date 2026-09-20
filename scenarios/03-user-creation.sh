#!/usr/bin/env bash
#
# Scenario 03 - rogue account creation
#
# Runs ON the target (post-compromise). Creates a backdoor account for
# persistence, which useradd logs to the journal.
#
# Detection:
#   {job="journald", host="target"} |= `new user`
#
# MITRE ATT&CK: T1136.001 Create Account: Local Account
#
set -euo pipefail

ROGUE_USER="${ROGUE_USER:-backdoor}"

echo "[*] Creating rogue account: ${ROGUE_USER}"
sudo useradd -m -s /bin/bash "${ROGUE_USER}"

echo "[*] Cleanup: removing ${ROGUE_USER} again"
sudo userdel -r "${ROGUE_USER}" 2>/dev/null || true

echo "[+] Done. Check the journal for the 'new user' event."

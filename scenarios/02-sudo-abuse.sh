#!/usr/bin/env bash
#
# Scenario 02 - sudo abuse
#
# Runs ON the target (post-compromise). A foothold account uses sudo to read
# a sensitive file, which sudo logs to the journal.
#
# Detection:
#   {job="journald", host="target", syslog_identifier="sudo"} |= `shadow`
#
# MITRE ATT&CK: T1548.003 Sudo and Sudo Caching
#
set -euo pipefail

echo "[*] Reading /etc/shadow via sudo"
sudo cat /etc/shadow >/dev/null
sudo cat /etc/gshadow >/dev/null 2>&1 || true

echo "[+] Done. Check the sudo Activity panel."

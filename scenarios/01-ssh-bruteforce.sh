#!/usr/bin/env bash
#
# Scenario 01 - SSH brute force
#
# Run from the attacker VM (Kali). Fires repeated SSH logins with invalid
# users to trip the fail2ban sshd jail on the target.
#
# Detection (check in Grafana afterwards):
#   Failed logins : sum(count_over_time({job="journald", host="target",
#                   syslog_identifier="sshd"} |~ `Failed password|invalid user` [5m]))
#   Ban issued    : {job="fail2ban", host="target"} |= `Ban `
#
# MITRE ATT&CK: T1110 Brute Force
#
set -euo pipefail

TARGET="${TARGET:-10.168.155.10}"
ATTEMPTS="${ATTEMPTS:-8}"   # jail maxRetry is 5, so 8 guarantees a ban

echo "[*] SSH brute force against ${TARGET} (${ATTEMPTS} attempts)"

for i in $(seq 1 "${ATTEMPTS}"); do
  ssh -o BatchMode=yes \
      -o StrictHostKeyChecking=no \
      -o UserKnownHostsFile=/dev/null \
      -o ConnectTimeout=2 \
      "attacker${i}@${TARGET}" true 2>/dev/null || true
  echo "    attempt ${i}/${ATTEMPTS}"
done

echo "[+] Done. Check the Detection Overview dashboard for the spike and ban."

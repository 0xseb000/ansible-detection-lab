# Attack Scenarios

Reproducible attacks used to verify the detection pipeline. Each attack is a
plain bash script so the steps are readable on their own; detection is checked
in the Grafana **Detection Overview** dashboard against the query listed below.

## Where each runs

| # | Scenario | Runs from | Simulates |
|---|----------|-----------|-----------|
| 01 | SSH brute force | attacker VM (Kali) | external attacker |
| 02 | sudo abuse | target (post-compromise) | insider / foothold |
| 03 | User creation | target (post-compromise) | persistence |

Network attacks come from the attacker VM. Post-compromise actions run on the
target itself, since they assume the attacker already has a foothold.

Set the target address once per shell:

```bash
export TARGET=10.168.155.10
```

## Detection matrix

| # | Attack | Detection query | Signal |
|---|--------|-----------------|--------|
| 01 | 8 failed SSH logins | `sum(count_over_time({job="journald", host="target", syslog_identifier="sshd"} \|~ \`Failed password\|invalid user\` [5m]))` | spike + fail2ban ban |
| 01 | fail2ban reaction | `{job="fail2ban", host="target"} \|= Ban` | ban event in log |
| 02 | sudo abuse | `{job="journald", host="target", syslog_identifier="sudo"}` | sudo command logged |
| 03 | user creation | `{job="journald", host="target"} \|= new user` | useradd logged |

## MITRE ATT&CK mapping

| # | Technique |
|---|-----------|
| 01 | T1110 Brute Force |
| 02 | T1548.003 Sudo and Sudo Caching |
| 03 | T1136.001 Create Account: Local Account |

## Running scenario 01

```bash
# on the attacker VM
export TARGET=10.168.155.10
./01-ssh-bruteforce.sh
```

Then open the dashboard, set the range to the last 15 minutes, and confirm the
failed-login spike and the ban.

## Running the target-side scenarios (02-03)

These run on the target. Pipe them in over Vagrant from the repo, no copy needed:

```bash
vagrant ssh target -- 'bash -s' < scenarios/02-sudo-abuse.sh
vagrant ssh target -- 'bash -s' < scenarios/03-user-creation.sh
```

## Note on the metrics alert

The `HostMetricsMissing` Prometheus rule (see `roles/w_prometheus`) detects a stopped agent through the *absence* of metrics - the case logs cannot catch.

# RHCSA EX200 9.3 — Practice Lab with Automated Validation

## Overview

This lab simulates the **Red Hat Certified System Administrator (RHCSA) EX200** exam based on **RHEL 9.3**. It contains **22 questions** across two servers (serverb and servera), with an automated validation script that scores your work and determines PASS/FAIL at the **70% threshold**

## Environment

| Property | Value |
|----------|-------|
| Domain | lab.example.com |
| Student Network | 172.25.250.0/24 |
| Classroom Network | 172.25.252.0/24 |
| bastion.lab.example.com | 172.25.250.254 (Gateway/Router) |
| workstation.lab.example.com | 172.25.250.9 (Graphical Workstation) |
| servera.lab.example.com | 172.25.250.10 (Managed Server A) |
| serverb.lab.example.com | 172.25.250.11 (Managed Server B) |
| User account | student / student |
| Root password (all systems) | redhat |
| Content server | content.example.com (repos) |
| Materials server | materials.example.com (lab materials) |
| NTP server | classroom.example.com |
| Container registry | docker.io (admin034 / redhat321) |

## Questions (22 Total)

### SERVERB Tasks (Q1-Q18)

| Q# | Topic | Domain | Weight |
|----|-------|--------|--------|
| Q1 | Configure Network | Manage Basic Networking | 5% |
| Q2 | Configure Repository | Manage Software Packages | 5% |
| Q3 | Create Users & Group | Manage Users & Groups | 6% |
| Q4 | SELinux WebServer Port 82 | Manage SELinux | 7% |
| Q5 | Shared Directory (SGID) | Manage File Permissions | 5% |
| Q6 | Automount NFS Home | Manage Storage | 6% |
| Q7 | Cron Job for harry | Schedule Tasks | 4% |
| Q8 | Create User alies (UID 1326) | Manage Users & Groups | 3% |
| Q9 | Find Files by User | Essential File Operations | 4% |
| Q10 | Tar Archive (gz & bz2) | Essential File Operations | 4% |
| Q11 | Find String (grep) | Essential File Operations | 3% |
| Q12 | NTP Client (chrony) | Manage Basic Networking | 4% |
| Q13 | Rootless Container Service | Manage Containers | 8% |
| Q14 | Umask for natasha | Manage File Permissions | 4% |
| Q15 | Password Expiry (20 days) | Manage Users & Groups | 3% |
| Q16 | Sudo for admin Group | Manage Users & Groups | 4% |
| Q17 | Login Message for alies | Manage Users & Groups | 3% |
| Q18 | Create Script mysearch | Shell Scripting | 4% |

### SERVERA Tasks (Q19-Q22)

| Q# | Topic | Domain | Weight |
|----|-------|--------|--------|
| Q19 | Break Root Password | Boot & Recovery | 5% |
| Q20 | Swap Partition (512M) | Manage Storage | 6% |
| Q21 | Logical Volume (LVM) | Manage Storage | 7% |
| Q22 | Resize Logical Volume | Manage Storage | 5% |

## Usage

### Setup and Solve a Question

```bash
# List all available questions
bash scripts/run-question.sh --list

# Run a specific question (setup + display)
bash scripts/run-question.sh "Question-3 Create-Users-Group"

# Solve the question...

# View the solution if needed
bash "Question-3 Create-Users-Group/SolutionNotes.bash"
```

### Validate Your Answers

```bash
# Validate ALL 22 questions
bash scripts/validate-rhcsa.sh

# Validate only serverb questions (1-18)
bash scripts/validate-rhcsa.sh --serverb

# Validate only servera questions (19-22)
bash scripts/validate-rhcsa.sh --servera

# Validate specific questions
bash scripts/validate-rhcsa.sh 1 3 5

# Validate a single question
bash scripts/validate-rhcsa.sh 4
```

### Recommended Workflow

1. Run `bash scripts/run-question.sh "Question-N ..."` to set up the lab
2. Read the question carefully
3. Solve the task using only the terminal (like the real exam)
4. Run `bash scripts/validate-rhcsa.sh N` to check your answer
5. If needed, read `SolutionNotes.bash` for the solution
6. Repeat for all 22 questions
7. Run `bash scripts/validate-rhcsa.sh` for the full exam score

## Scoring

The validator uses **weighted scoring** across all 22 questions:

- Each question has multiple granular checks
- Partial credit is awarded for partially completed tasks
- Final score is a weighted percentage
- **Passing score: 70%** (matching the real RHCSA exam)
- Exit code: `0` = PASSED, `1` = FAILED

## RHCSA Exam Domains Covered

| Domain | Questions |
|--------|-----------|
| Manage Basic Networking | Q1, Q12 |
| Manage Software Packages | Q2 |
| Manage Users & Groups | Q3, Q8, Q15, Q16, Q17 |
| Manage SELinux | Q4 |
| Manage File Permissions | Q5, Q14 |
| Manage Storage | Q6, Q20, Q21, Q22 |
| Schedule Tasks | Q7 |
| Essential File Operations | Q9, Q10, Q11 |
| Manage Containers | Q13 |
| Shell Scripting | Q18 |
| Boot & Recovery | Q19 |

## Notes

- Questions Q19-Q22 require SSH access to **servera** — complete Q19 (Break Root Password) first
- The validator for servera questions uses SSH to connect and verify
- Install `sshpass` if password-based SSH verification is needed: `dnf install -y sshpass`
- Some questions depend on others (e.g., Q14 needs Q3 users, Q22 needs Q21 LVM)

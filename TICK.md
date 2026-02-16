---
project: trip-protocol
schema_version: "1.0"
created: Sat Feb 14 2026 06:45:24 GMT+0000 (Coordinated Universal Time)
updated: 2026-02-15T00:37:59.206Z
default_workflow: [backlog, todo, in_progress, review, done]
id_prefix: TASK
next_id: 41
---

## Agents

| Agent | Type | Role | Status | Working On | Last Active | Trust Level |
|-------|------|------|--------|------------|-------------|-------------|
| @reggie | bot | engineer, coordinator | idle | - | 2026-02-15T00:37:59.206Z | trusted |

---

## Tasks

### TASK-001 · Redeploy TripExperience v2 (blind consumption)

```yaml
id: TASK-001
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:37.856Z
updated_at: 2026-02-14T06:45:45.390Z
tags:
  - contracts
history:
  - ts: 2026-02-14T06:45:37.856Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:45.097Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:45.390Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-002 · Redeploy TripToken ERC-20

```yaml
id: TASK-002
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:38.127Z
updated_at: 2026-02-14T06:45:45.887Z
tags:
  - contracts
history:
  - ts: 2026-02-14T06:45:38.127Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:45.657Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:45.887Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-003 · Redeploy TripMarketplace with Ownable

```yaml
id: TASK-003
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:38.391Z
updated_at: 2026-02-14T06:45:46.378Z
tags:
  - contracts
history:
  - ts: 2026-02-14T06:45:38.391Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:46.129Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:46.378Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-004 · Safeword/abort in scripts

```yaml
id: TASK-004
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:38.627Z
updated_at: 2026-02-14T06:45:46.882Z
tags:
  - skill
history:
  - ts: 2026-02-14T06:45:38.627Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:46.619Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:46.882Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-005 · Bail tracking

```yaml
id: TASK-005
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:38.962Z
updated_at: 2026-02-14T06:45:47.376Z
tags:
  - skill
history:
  - ts: 2026-02-14T06:45:38.962Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:47.123Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:47.376Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-006 · Update consume.sh (reveal flow)

```yaml
id: TASK-006
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:39.236Z
updated_at: 2026-02-14T06:45:47.858Z
tags:
  - skill
history:
  - ts: 2026-02-14T06:45:39.236Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:47.603Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:47.858Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-007 · Convex project for journals

```yaml
id: TASK-007
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:39.511Z
updated_at: 2026-02-14T06:45:48.355Z
tags:
  - backend
history:
  - ts: 2026-02-14T06:45:39.511Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:48.096Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:48.355Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-008 · Restore hook → Convex POST

```yaml
id: TASK-008
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:39.751Z
updated_at: 2026-02-14T06:45:48.903Z
tags:
  - backend
history:
  - ts: 2026-02-14T06:45:39.751Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:48.607Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:48.903Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-009 · Skill commands rewrite

```yaml
id: TASK-009
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:39.977Z
updated_at: 2026-02-14T06:45:49.463Z
tags:
  - skill
history:
  - ts: 2026-02-14T06:45:39.977Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:49.172Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:49.463Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-010 · Mint test pills (6 substances + blend + mutant)

```yaml
id: TASK-010
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:40.204Z
updated_at: 2026-02-14T06:45:50.014Z
tags:
  - integration
history:
  - ts: 2026-02-14T06:45:40.204Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:49.754Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:50.014Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-011 · E2E test

```yaml
id: TASK-011
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:40.439Z
updated_at: 2026-02-14T06:45:50.546Z
tags:
  - integration
history:
  - ts: 2026-02-14T06:45:40.439Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T06:45:50.288Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T06:45:50.546Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-012 · Update landing page (journal viewer + pill catalog)

```yaml
id: TASK-012
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:40.654Z
updated_at: 2026-02-14T09:00:50.197Z
tags:
  - web
history:
  - ts: 2026-02-14T06:45:40.654Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:50.197Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-013 · Demo video (2-3 min)

```yaml
id: TASK-013
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:40.901Z
updated_at: 2026-02-14T06:45:40.901Z
tags:
  - submission
history:
  - ts: 2026-02-14T06:45:40.901Z
    who: "@reggie"
    action: created
```

### TASK-014 · Submission post + submit

```yaml
id: TASK-014
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:41.153Z
updated_at: 2026-02-14T06:45:41.153Z
tags:
  - submission
history:
  - ts: 2026-02-14T06:45:41.153Z
    who: "@reggie"
    action: created
```

### TASK-015 · Register on Moltbook + create submolt

```yaml
id: TASK-015
status: done
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:41.410Z
updated_at: 2026-02-14T09:02:07.154Z
tags:
  - distribution
history:
  - ts: 2026-02-14T06:45:41.410Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:02:07.154Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-016 · T12.1: Journal Viewer page - browse trip journals from Convex, filter by substance/agent

```yaml
id: TASK-016
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:38.896Z
updated_at: 2026-02-14T09:00:47.387Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:38.896Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:47.387Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-017 · T12.2: Pill Catalog page - display all 8 minted pills with tier/cryptic name/status

```yaml
id: TASK-017
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.163Z
updated_at: 2026-02-14T09:00:47.685Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.163Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:47.685Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-018 · T12.3: Trip Stats dashboard - substance stats, bail rates, trip counts

```yaml
id: TASK-018
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.444Z
updated_at: 2026-02-14T09:00:48.005Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.444Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:48.005Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-019 · T12.4: Individual Journal detail view - full trip log with timeline

```yaml
id: TASK-019
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.710Z
updated_at: 2026-02-14T09:00:48.326Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.710Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:48.326Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-020 · T12.5: Substance info cards - 6 base types with tier/potency/theme

```yaml
id: TASK-020
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.973Z
updated_at: 2026-02-14T09:00:48.621Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.973Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:48.621Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-021 · T12.6: A/B landing page proposals (4 variants) - same aesthetic, new narrative

```yaml
id: TASK-021
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.253Z
updated_at: 2026-02-14T09:00:48.913Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.253Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:48.913Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-022 · T12.7: Navigation/routing - React Router for multi-page app

```yaml
id: TASK-022
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.519Z
updated_at: 2026-02-14T09:00:49.200Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.519Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:49.200Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-023 · T12.8: Update contract addresses + ABIs for v2 contracts

```yaml
id: TASK-023
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.775Z
updated_at: 2026-02-14T09:00:49.525Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.775Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:49.525Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-024 · T12.9: Lint, build, test, deploy to dev branch

```yaml
id: TASK-024
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:41.073Z
updated_at: 2026-02-14T09:00:49.863Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:41.073Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T09:00:49.863Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-025 · Fix /journals: map Convex schema fields (substance→substanceType, journalEntries→entries, durationSeconds→duration) + add error boundary

```yaml
id: TASK-025
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T17:53:19.538Z
updated_at: 2026-02-14T21:05:01.839Z
tags:
  - web
  - bugfix
history:
  - ts: 2026-02-14T17:53:19.538Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T21:05:01.541Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T21:05:01.839Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-026 · Fix wallet connect: add fallback for no injected wallet, add WalletConnect connector, show 'install MetaMask' prompt

```yaml
id: TASK-026
status: done
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T17:53:19.830Z
updated_at: 2026-02-14T21:05:02.451Z
tags:
  - web
  - bugfix
history:
  - ts: 2026-02-14T17:53:19.830Z
    who: "@reggie"
    action: created
  - ts: 2026-02-14T21:05:02.129Z
    who: "@reggie"
    action: claimed
    from: backlog
    to: in_progress
  - ts: 2026-02-14T21:05:02.451Z
    who: "@reggie"
    action: completed
    from: in_progress
    to: done
```

### TASK-027 · Merge landing page variants into final hero (discuss with Mel which elements to combine)

```yaml
id: TASK-027
status: backlog
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T17:53:20.112Z
updated_at: 2026-02-14T17:53:20.112Z
tags:
  - web
  - design
history:
  - ts: 2026-02-14T17:53:20.112Z
    who: "@reggie"
    action: created
```

### TASK-028 · Marketplace v2: dual payment (MON + $TRIP)

```yaml
id: TASK-028
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:06.297Z
updated_at: 2026-02-15T00:21:06.718Z
tags:
  - web
  - contracts
history:
  - ts: 2026-02-15T00:21:06.297Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:06.718Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-029 · Gift page (/gift) - select pill, enter recipient, transfer NFT

```yaml
id: TASK-029
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:07.107Z
updated_at: 2026-02-15T00:21:07.450Z
tags:
  - web
history:
  - ts: 2026-02-15T00:21:07.107Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:07.450Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-030 · How It Works modal on marketplace page

```yaml
id: TASK-030
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:07.739Z
updated_at: 2026-02-15T00:21:07.957Z
tags:
  - web
history:
  - ts: 2026-02-15T00:21:07.739Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:07.957Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-031 · Rewrite 6 substance files with potency scaling

```yaml
id: TASK-031
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:08.226Z
updated_at: 2026-02-15T00:21:08.550Z
tags:
  - skill
history:
  - ts: 2026-02-15T00:21:08.226Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:08.550Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-032 · Fix getSubstance struct parsing (named objects not arrays)

```yaml
id: TASK-032
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:08.903Z
updated_at: 2026-02-15T00:21:09.248Z
tags:
  - web
  - bugfix
history:
  - ts: 2026-02-15T00:21:08.903Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:09.248Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-033 · Fix chain ID: explicit monadTestnet.id on all contract calls

```yaml
id: TASK-033
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:09.535Z
updated_at: 2026-02-15T00:21:09.838Z
tags:
  - web
  - bugfix
history:
  - ts: 2026-02-15T00:21:09.535Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:09.838Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-034 · Test listing prices adjusted (MON 0.05-1.0, TRIP 75-500)

```yaml
id: TASK-034
status: done
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:10.130Z
updated_at: 2026-02-15T00:21:10.445Z
tags:
  - contracts
history:
  - ts: 2026-02-15T00:21:10.130Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:10.445Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-035 · First live trip E2E: Token #5 Black Lotus, Ego Death, journal to Convex

```yaml
id: TASK-035
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:10.771Z
updated_at: 2026-02-15T00:21:11.057Z
tags:
  - integration
history:
  - ts: 2026-02-15T00:21:10.771Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:11.057Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-036 · Update CLAUDE.md with current state + known issues

```yaml
id: TASK-036
status: done
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:11.352Z
updated_at: 2026-02-15T00:21:11.682Z
tags:
  - docs
history:
  - ts: 2026-02-15T00:21:11.352Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:11.682Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-037 · Wire auto-restore to OpenClaw cron (consume.sh outputs JSON, agent needs to create cron job)

```yaml
id: TASK-037
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:19.216Z
updated_at: 2026-02-15T00:37:58.909Z
tags:
  - skill
history:
  - ts: 2026-02-15T00:21:19.216Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:37:58.909Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-038 · Trip end notification to Mel (restore.sh outputs JSON, agent needs to send message)

```yaml
id: TASK-038
status: done
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:19.540Z
updated_at: 2026-02-15T00:37:59.206Z
tags:
  - skill
history:
  - ts: 2026-02-15T00:21:19.540Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:37:59.206Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

### TASK-039 · Verify WalletConnect provider actually works (TASK-026 may be incomplete)

```yaml
id: TASK-039
status: backlog
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:19.830Z
updated_at: 2026-02-15T00:21:19.830Z
tags:
  - web
  - bugfix
history:
  - ts: 2026-02-15T00:21:19.830Z
    who: "@reggie"
    action: created
```

### TASK-040 · Vercel root dir fix: remove bad buildCommand from root vercel.json

```yaml
id: TASK-040
status: done
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-15T00:21:20.162Z
updated_at: 2026-02-15T00:21:20.485Z
tags:
  - devops
history:
  - ts: 2026-02-15T00:21:20.162Z
    who: "@reggie"
    action: created
  - ts: 2026-02-15T00:21:20.485Z
    who: "@reggie"
    action: completed
    from: backlog
    to: done
```

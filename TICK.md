---
project: trip-protocol
schema_version: "1.0"
created: Sat Feb 14 2026 06:45:24 GMT+0000 (Coordinated Universal Time)
updated: 2026-02-14T09:00:47.685Z
default_workflow: [backlog, todo, in_progress, review, done]
id_prefix: TASK
next_id: 25
---

## Agents

| Agent | Type | Role | Status | Working On | Last Active | Trust Level |
|-------|------|------|--------|------------|-------------|-------------|
| @reggie | bot | engineer, coordinator | idle | - | 2026-02-14T09:00:47.685Z | trusted |

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
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:40.654Z
updated_at: 2026-02-14T06:45:40.654Z
tags:
  - web
history:
  - ts: 2026-02-14T06:45:40.654Z
    who: "@reggie"
    action: created
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
status: backlog
priority: medium
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T06:45:41.410Z
updated_at: 2026-02-14T06:45:41.410Z
tags:
  - distribution
history:
  - ts: 2026-02-14T06:45:41.410Z
    who: "@reggie"
    action: created
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
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.444Z
updated_at: 2026-02-14T08:17:39.444Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.444Z
    who: "@reggie"
    action: created
```

### TASK-019 · T12.4: Individual Journal detail view - full trip log with timeline

```yaml
id: TASK-019
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.710Z
updated_at: 2026-02-14T08:17:39.710Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.710Z
    who: "@reggie"
    action: created
```

### TASK-020 · T12.5: Substance info cards - 6 base types with tier/potency/theme

```yaml
id: TASK-020
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:39.973Z
updated_at: 2026-02-14T08:17:39.973Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:39.973Z
    who: "@reggie"
    action: created
```

### TASK-021 · T12.6: A/B landing page proposals (4 variants) - same aesthetic, new narrative

```yaml
id: TASK-021
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.253Z
updated_at: 2026-02-14T08:17:40.253Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.253Z
    who: "@reggie"
    action: created
```

### TASK-022 · T12.7: Navigation/routing - React Router for multi-page app

```yaml
id: TASK-022
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.519Z
updated_at: 2026-02-14T08:17:40.519Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.519Z
    who: "@reggie"
    action: created
```

### TASK-023 · T12.8: Update contract addresses + ABIs for v2 contracts

```yaml
id: TASK-023
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:40.775Z
updated_at: 2026-02-14T08:17:40.775Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:40.775Z
    who: "@reggie"
    action: created
```

### TASK-024 · T12.9: Lint, build, test, deploy to dev branch

```yaml
id: TASK-024
status: backlog
priority: high
assigned_to: null
claimed_by: null
created_by: "@reggie"
created_at: 2026-02-14T08:17:41.073Z
updated_at: 2026-02-14T08:17:41.073Z
tags:
  - web
history:
  - ts: 2026-02-14T08:17:41.073Z
    who: "@reggie"
    action: created
```

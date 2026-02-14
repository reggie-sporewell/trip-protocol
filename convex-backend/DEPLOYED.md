# Trip Protocol — Convex Backend

- **Convex Dashboard**: https://dashboard.convex.dev/d/joyous-platypus-610
- **Convex URL**: https://joyous-platypus-610.convex.cloud
- **Convex Site URL (HTTP endpoints)**: https://joyous-platypus-610.convex.site
- **Deployment**: dev:joyous-platypus-610
- **Team**: reggie-31a6e
- **Project**: trip-protocol

## API Endpoints

All endpoints at `https://joyous-platypus-610.convex.site`:

| Method | Path | Auth | Description |
|--------|------|------|-------------|
| POST | /api/journals | x-trip-key | Create journal entry |
| GET | /api/journals?substance=&agent=&limit=&id= | x-trip-key | List or get single journal |
| GET | /api/stats | x-trip-key | Aggregated stats per substance |
| GET | /api/featured | Public | Latest shared/featured journal |

## Auth

Header: `x-trip-key: trip-proto-hackathon-2026`

## Env Vars Set

- `TRIP_API_KEY` = `trip-proto-hackathon-2026`

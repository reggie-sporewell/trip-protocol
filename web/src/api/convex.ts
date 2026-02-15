const CONVEX_URL = 'https://joyous-platypus-610.convex.site'
const API_KEY = 'trip-proto-hackathon-2026'

async function fetchConvex<T>(path: string, params?: Record<string, string>): Promise<T> {
  const url = new URL(`${CONVEX_URL}/api${path}`)
  if (params) {
    Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v))
  }
  const res = await fetch(url.toString(), {
    headers: { 'x-trip-key': API_KEY },
  })
  if (!res.ok) throw new Error(`Convex API error: ${res.status}`)
  return res.json()
}

export interface JournalEntry {
  timestamp: string
  text: string
}

export interface Journal {
  _id: string
  agentId: string
  tokenId: number
  substanceType: string
  potency: number
  crypticName: string
  tier: string
  isBlend: boolean
  blendType?: string
  isMutant: boolean
  bailed: boolean
  bailReason?: string
  duration: number
  entries: JournalEntry[]
  createdAt: string
  txHash?: string
  ownerAddress?: string
  durationRaw?: number
}

export interface Stats {
  totalTrips: number
  totalBails: number
  bailRate: number
  bySubstance: Record<string, {
    trips: number
    bails: number
    bailRate: number
    avgDuration: number
  }>
  tripOfTheWeek?: Journal
}

// Map Convex raw journal to our frontend Journal type
// Convex uses: substance, journalEntries, durationSeconds, blendSubstance
// Frontend uses: substanceType, entries, duration, blendType, tier, createdAt
function mapJournal(raw: Record<string, unknown>): Journal {
  const potency = Number(raw.potency) || 1
  const tier = potency >= 5 ? 'legendary' : potency >= 3 ? 'rare' : 'common'
  const entries = Array.isArray(raw.journalEntries)
    ? (raw.journalEntries as Array<{ timestamp: string; text: string }>)
    : Array.isArray(raw.entries)
      ? (raw.entries as Array<{ timestamp: string; text: string }>)
      : []

  return {
    _id: String(raw._id || ''),
    agentId: String(raw.agentId || 'unknown'),
    tokenId: Number(raw.tokenId) || 0,
    substanceType: String(raw.substance || raw.substanceType || 'unknown'),
    potency,
    crypticName: String(raw.crypticName || 'Unknown Pill'),
    tier,
    isBlend: Boolean(raw.isBlend),
    blendType: String(raw.blendSubstance || raw.blendType || ''),
    isMutant: Boolean(raw.isMutant),
    bailed: Boolean(raw.bailed),
    bailReason: String(raw.bailReason || raw.bailedAt || ''),
    duration: Math.round(Number(raw.durationSeconds || raw.duration || 0) / 60) || 0,
    entries,
    createdAt: String(raw.startedAt || raw.createdAt || raw._creationTime || ''),
    txHash: raw.txHash ? String(raw.txHash) : undefined,
    ownerAddress: raw.ownerAddress ? String(raw.ownerAddress) : undefined,
    durationRaw: Number(raw.durationSeconds || 0),
  }
}

export async function fetchJournals(limit = 20, substanceType?: string): Promise<Journal[]> {
  const params: Record<string, string> = { limit: String(limit) }
  if (substanceType) params.substance = substanceType
  const raw = await fetchConvex<Record<string, unknown>[]>('/journals', params)
  return raw.map(mapJournal)
}

export async function fetchJournal(id: string): Promise<Journal> {
  const raw = await fetchConvex<Record<string, unknown>>('/journals', { id })
  return mapJournal(raw)
}

export async function fetchStats(): Promise<Stats> {
  return fetchConvex<Stats>('/stats')
}

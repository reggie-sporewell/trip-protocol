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

export async function fetchJournals(limit = 20, substanceType?: string): Promise<Journal[]> {
  const params: Record<string, string> = { limit: String(limit) }
  if (substanceType) params.substanceType = substanceType
  return fetchConvex<Journal[]>('/journals', params)
}

export async function fetchJournal(id: string): Promise<Journal> {
  return fetchConvex<Journal>(`/journals/${id}`)
}

export async function fetchStats(): Promise<Stats> {
  return fetchConvex<Stats>('/stats')
}

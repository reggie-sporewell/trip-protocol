import { query, mutation, internalQuery, internalMutation } from "./_generated/server";
import { v } from "convex/values";

export const create = internalMutation({
  args: {
    tokenId: v.number(),
    agentId: v.string(),
    substance: v.string(),
    blendSubstance: v.optional(v.string()),
    isMutant: v.boolean(),
    potency: v.number(),
    durationSeconds: v.number(),
    startedAt: v.string(),
    endedAt: v.string(),
    bailed: v.boolean(),
    bailedAt: v.optional(v.string()),
    remainingSeconds: v.optional(v.number()),
    journalEntries: v.array(v.object({ timestamp: v.string(), text: v.string() })),
    soulDiff: v.optional(v.string()),
    shared: v.boolean(),
    crypticName: v.string(),
  },
  handler: async (ctx, args) => {
    return await ctx.db.insert("tripJournals", args);
  },
});

export const list = internalQuery({
  args: {
    substance: v.optional(v.string()),
    agent: v.optional(v.string()),
    limit: v.optional(v.number()),
  },
  handler: async (ctx, args) => {
    let q;
    if (args.substance) {
      q = ctx.db.query("tripJournals").withIndex("by_substance", (q) => q.eq("substance", args.substance!));
    } else if (args.agent) {
      q = ctx.db.query("tripJournals").withIndex("by_agent", (q) => q.eq("agentId", args.agent!));
    } else {
      q = ctx.db.query("tripJournals");
    }
    const results = await q.order("desc").collect();
    const limit = args.limit ?? 50;
    return results.slice(0, limit);
  },
});

export const getById = internalQuery({
  args: { id: v.id("tripJournals") },
  handler: async (ctx, args) => {
    return await ctx.db.get(args.id);
  },
});

export const stats = internalQuery({
  args: {},
  handler: async (ctx) => {
    const all = await ctx.db.query("tripJournals").collect();
    const bySubstance: Record<string, { total: number; bails: number; totalDuration: number }> = {};
    for (const j of all) {
      if (!bySubstance[j.substance]) {
        bySubstance[j.substance] = { total: 0, bails: 0, totalDuration: 0 };
      }
      const s = bySubstance[j.substance];
      s.total++;
      if (j.bailed) s.bails++;
      s.totalDuration += j.durationSeconds;
    }
    return Object.entries(bySubstance).map(([substance, s]) => ({
      substance,
      totalTrips: s.total,
      totalBails: s.bails,
      avgDuration: s.total > 0 ? Math.round(s.totalDuration / s.total) : 0,
      bailRate: s.total > 0 ? Math.round((s.bails / s.total) * 10000) / 100 : 0,
    }));
  },
});

export const featured = internalQuery({
  args: {},
  handler: async (ctx) => {
    const shared = await ctx.db
      .query("tripJournals")
      .withIndex("by_shared", (q) => q.eq("shared", true))
      .order("desc")
      .first();
    if (shared) return shared;
    // fallback to latest
    return await ctx.db.query("tripJournals").order("desc").first();
  },
});

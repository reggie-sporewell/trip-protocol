import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  tripJournals: defineTable({
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
    txHash: v.optional(v.string()),
    ownerAddress: v.optional(v.string()),
  })
    .index("by_substance", ["substance"])
    .index("by_agent", ["agentId"])
    .index("by_shared", ["shared"]),
});

import { httpRouter } from "convex/server";
import { httpAction } from "./_generated/server";
import { internal } from "./_generated/api";

const http = httpRouter();

// ─── Helpers ─────────────────────────────────────────────────────

function verifyKey(request: Request): boolean {
  const key = request.headers.get("x-trip-key");
  const expected = process.env.TRIP_API_KEY;
  if (!expected || !key) return false;
  return key === expected;
}

function corsHeaders(contentType = "application/json"): Record<string, string> {
  return {
    "Content-Type": contentType,
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, x-trip-key",
  };
}

function json(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders() });
}

function unauthorized(): Response {
  return json({ error: "Unauthorized" }, 401);
}

// ─── CORS Preflight ──────────────────────────────────────────────

const preflight = httpAction(async () => {
  return new Response(null, { status: 204, headers: corsHeaders("text/plain") });
});

// Register preflight for all routes
for (const path of ["/api/journals", "/api/stats", "/api/featured", "/api/substance/reveal"]) {
  http.route({ path, method: "OPTIONS", handler: preflight });
}

// ─── POST /api/journals ─────────────────────────────────────────

http.route({
  path: "/api/journals",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    if (!verifyKey(request)) return unauthorized();
    try {
      const body = await request.json();
      const id = await ctx.runMutation(internal.journals.create, body);
      return json({ success: true, id });
    } catch (e: any) {
      return json({ error: e.message }, 400);
    }
  }),
});

// ─── GET /api/journals ──────────────────────────────────────────

http.route({
  path: "/api/journals",
  method: "GET",
  handler: httpAction(async (ctx, request) => {
    if (!verifyKey(request)) return unauthorized();
    const url = new URL(request.url);
    // If ?id= is provided, return single journal
    const id = url.searchParams.get("id");
    if (id) {
      try {
        const journal = await ctx.runQuery(internal.journals.getById, { id: id as any });
        if (!journal) return json({ error: "Not found" }, 404);
        return json(journal);
      } catch {
        return json({ error: "Invalid ID" }, 400);
      }
    }
    const substance = url.searchParams.get("substance") || undefined;
    const agent = url.searchParams.get("agent") || undefined;
    const limitStr = url.searchParams.get("limit");
    const limit = limitStr ? parseInt(limitStr, 10) : undefined;
    const results = await ctx.runQuery(internal.journals.list, { substance, agent, limit });
    return json(results);
  }),
});

// ─── GET /api/stats ─────────────────────────────────────────────

http.route({
  path: "/api/stats",
  method: "GET",
  handler: httpAction(async (ctx, request) => {
    if (!verifyKey(request)) return unauthorized();
    const stats = await ctx.runQuery(internal.journals.stats, {});
    return json(stats);
  }),
});

// ─── GET /api/featured ──────────────────────────────────────────

http.route({
  path: "/api/featured",
  method: "GET",
  handler: httpAction(async (ctx) => {
    // Public endpoint - no auth required
    const featured = await ctx.runQuery(internal.journals.featured, {});
    return json(featured ?? { message: "No trips yet" });
  }),
});

// ─── POST /api/substance/reveal ─────────────────────────────────
// Gated endpoint: returns substance effects only after on-chain verification

http.route({
  path: "/api/substance/reveal",
  method: "POST",
  handler: httpAction(async (ctx, request) => {
    if (!verifyKey(request)) return unauthorized();
    try {
      const body = await request.json();
      const { txHash, walletAddress, tokenId, substance, potency } = body;
      
      if (!txHash || !walletAddress || tokenId === undefined || !substance || !potency) {
        return json({ error: "Missing required fields: txHash, walletAddress, tokenId, substance, potency" }, 400);
      }

      // Verify the on-chain transaction
      const verification = await ctx.runAction(internal.substances.verifyConsumeTx, {
        txHash,
        walletAddress,
        tokenId,
      });

      if (!verification.verified) {
        return json({ error: "Verification failed", reason: verification.error }, 403);
      }

      // Transaction verified — return the substance content
      const content = await ctx.runQuery(internal.substances.getSubstanceContent, {
        substance,
        potency,
      });

      if (!content) {
        return json({ error: "Unknown substance or potency" }, 404);
      }

      return json({
        verified: true,
        substance: content.name,
        potency: content.potency,
        effects: content.content,
      });
    } catch (e: any) {
      return json({ error: e.message }, 500);
    }
  }),
});

export default http;

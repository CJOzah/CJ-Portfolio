import express from "express";

const app = express();
const port = Number(process.env.PORT || 3000);

/**
 * Validates a requested upstream URL and ensures only GitHub API is allowed.
 */
function parseAndValidateTargetUrl(rawUrl) {
  if (!rawUrl || typeof rawUrl !== "string" || !rawUrl.trim()) {
    return { error: "Missing url query param" };
  }
  let targetUrl;
  try {
    targetUrl = new URL(rawUrl);
  } catch (_) {
    return { error: "Invalid url query param" };
  }
  if (targetUrl.protocol !== "https:" || targetUrl.hostname !== "api.github.com") {
    return { error: "Only https://api.github.com is allowed" };
  }
  return { targetUrl };
}

/**
 * Returns CORS origin value from env allow-list.
 */
function getCorsOrigin(requestOrigin) {
  const allowedOriginsRaw = process.env.ALLOWED_ORIGINS || "";
  if (!allowedOriginsRaw.trim()) {
    return "*";
  }
  const allowedOrigins = allowedOriginsRaw
    .split(",")
    .map((item) => item.trim())
    .filter((item) => item.length > 0);
  if (allowedOrigins.includes(requestOrigin || "")) {
    return requestOrigin;
  }
  return "null";
}

app.get("/health", (_, response) => {
  response.status(200).json({ ok: true });
});

app.options("/api/github-proxy", (request, response) => {
  response.setHeader("Access-Control-Allow-Origin", getCorsOrigin(request.headers.origin));
  response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
  response.setHeader("Access-Control-Allow-Headers", "Content-Type");
  response.status(204).send();
});

app.get("/api/github-proxy", async (request, response) => {
  const token = process.env.GITHUB_TOKEN || "";
  if (!token.trim()) {
    response.status(500).json({ error: "Missing server GITHUB_TOKEN" });
    return;
  }

  const { targetUrl, error } = parseAndValidateTargetUrl(request.query.url);
  if (error) {
    response.status(400).json({ error });
    return;
  }

  try {
    const upstreamResponse = await fetch(targetUrl.toString(), {
      method: "GET",
      headers: {
        "Accept": "application/vnd.github+json",
        "Authorization": `Bearer ${token}`,
        "User-Agent": "cj-portfolio-proxy",
        "X-GitHub-Api-Version": "2022-11-28",
      },
    });
    const responseBody = await upstreamResponse.text();
    response.setHeader("Access-Control-Allow-Origin", getCorsOrigin(request.headers.origin));
    response.setHeader("Cache-Control", "public, max-age=60");
    const contentType = upstreamResponse.headers.get("content-type");
    if (contentType) {
      response.setHeader("Content-Type", contentType);
    }
    response.status(upstreamResponse.status).send(responseBody);
  } catch (_) {
    response.status(502).json({ error: "Failed to reach GitHub API" });
  }
});

app.listen(port, () => {
  console.log(`GitHub proxy service listening on port ${port};`);
});

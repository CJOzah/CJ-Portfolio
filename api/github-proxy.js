export default async function handler(request, response) {
  if (request.method !== "GET") {
    response.status(405).json({ error: "Method not allowed" });
    return;
  }

  const token = process.env.GITHUB_TOKEN || "";
  if (!token.trim()) {
    response.status(500).json({ error: "Missing server GITHUB_TOKEN" });
    return;
  }

  const requestedUrl = typeof request.query.url === "string" ? request.query.url : "";
  if (!requestedUrl.trim()) {
    response.status(400).json({ error: "Missing url query param" });
    return;
  }

  let targetUrl;
  try {
    targetUrl = new URL(requestedUrl);
  } catch (_) {
    response.status(400).json({ error: "Invalid url query param" });
    return;
  }

  if (targetUrl.protocol !== "https:" || targetUrl.hostname !== "api.github.com") {
    response.status(400).json({ error: "Only https://api.github.com is allowed" });
    return;
  }

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
  response.setHeader("Access-Control-Allow-Origin", "*");
  response.setHeader("Cache-Control", "s-maxage=60, stale-while-revalidate=300");
  const contentType = upstreamResponse.headers.get("content-type");
  if (contentType) {
    response.setHeader("Content-Type", contentType);
  }
  response.status(upstreamResponse.status).send(responseBody);
}

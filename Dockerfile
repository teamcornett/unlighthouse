# Production-oriented image: Node 22 + Chromium for Lighthouse / Unlighthouse / Puppeteer.
# Pin to Oct 2026 security release (https://nodejs.org/en/blog/vulnerability/october-2026-security-releases).
FROM node:22.23.4-bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    chromium \
    ca-certificates \
    fonts-liberation \
  && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV=production
ENV CHROME_PATH=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true

WORKDIR /app
COPY package.json package-lock.json ./
COPY scripts ./scripts
RUN npm ci --omit=dev

COPY server.js ./
COPY lib ./lib
COPY views ./views

# Railway sets PORT at runtime; default 4173 for local Docker.
ENV PORT=4173
EXPOSE 4173

CMD ["node", "server.js"]

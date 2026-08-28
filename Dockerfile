# syntax=docker/dockerfile:1
#
# Digest-pinned to avoid tag-resolution / registry-metadata timeouts during
# build (see build 019f5585-edd0-788d-8304-b701eb514358). Bump both the tag
# and digest together when updating; Dependabot keeps this current.
FROM node:20-bookworm-slim@sha256:2cf067cfed83d5ea958367df9f966191a942351a2df77d6f0193e162b5febfc0 AS builder

WORKDIR /app

# Install dependencies before copying source so this layer is cached across
# source-only changes.
COPY package.json package-lock.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src
RUN npm run build


FROM node:20-bookworm-slim@sha256:2cf067cfed83d5ea958367df9f966191a942351a2df77d6f0193e162b5febfc0 AS runtime

ENV NODE_ENV=production

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
    && npm install -g mcp-proxy@6.4.3 \
    && npm cache clean --force

COPY --from=builder /app/dist ./dist

# Official node image ships a non-root "node" user; run as it rather than root.
USER node

CMD ["mcp-proxy", "--", "node", "dist/index.js"]

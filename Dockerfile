FROM node:20-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    openssl \
    ffmpeg \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install package dependencies
COPY antisnowflake-bot-main/package*.json ./
RUN npm install --omit=dev --legacy-peer-deps

# Copy application files
COPY antisnowflake-bot-main/ ./

# Pre-create writable runtime directories
RUN mkdir -p /app/data/sessions \
             /app/data/flow_sessions \
             /app/data/memory \
             /app/data/config \
             /app/catalog \
             /app/tmp/pair_sessions \
             /app/temp \
             /app/scratch && \
    [ -f /app/data/owner.json ] || echo '["237653683174"]' > /app/data/owner.json

# Expose port for Railway / Cloud deployment
EXPOSE 8080 7860

ENV PORT=8080
ENV NODE_ENV=production

CMD ["node", "--no-warnings", "--expose-gc", "--max-old-space-size=400", "preload.js"]

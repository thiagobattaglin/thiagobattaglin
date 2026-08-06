# Build stage
FROM node:22-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

# Production stage
FROM node:22-alpine

WORKDIR /app

# Criar usuário não-root
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

COPY --from=build /app /app

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 4004

ENV NODE_ENV=production
ENV PORT=4004

CMD ["npx", "cds-serve"]

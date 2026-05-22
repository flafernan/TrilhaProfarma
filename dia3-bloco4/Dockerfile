# Stage 1: Build (Instala dependências e prepara o ambiente)
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci

# Stage 2: Run (Imagem final, limpa e leve apenas com o necessário)
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
CMD ["node", "index.js"]
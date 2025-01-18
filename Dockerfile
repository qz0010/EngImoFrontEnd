# Первый этап: сборка (builder)
FROM node:20 as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . .
RUN npm run build:prod


# Второй этап: минимальный образ для запуска приложения
FROM node:20-alpine as production

WORKDIR /app

# Копируем собранное приложение из первого этапа
COPY --from=builder /app/dist /app/dist

# Копируем package*.json
COPY package*.json ./

# Устанавливаем продакшен-зависимости
RUN npm ci --production

EXPOSE 8080

CMD ["npm", "run", "serve:prod"]

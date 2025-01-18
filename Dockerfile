# Установим базовый образ Node.js для сборки приложения
FROM node:20 as builder

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json для установки зависимостей
COPY package*.json ./

# Устанавливаем зависимости
RUN npm ci

# Копируем исходный код приложения
COPY . .

# Сборка приложения и серверной части (SSR)
RUN npm run build:prod

# Второй этап: минимальный образ для запуска приложения

# Копируем собранное приложение из предыдущей стадии
COPY --from=builder /app/dist /app/dist

# Устанавливаем зависимости только для продакшена
COPY package*.json ./
RUN npm ci --production

# Экспонируем порт
EXPOSE 4000

# Команда для запуска SSR
#CMD ["node", "dist/base-frontend/server/server.mjs"]
RUN npm run serve:prod

# устанавливаем официальный образ Node.js
FROM node:20 as builder

# указываем рабочую (корневую) директорию
WORKDIR /app

# копируем основные файлы приложения в рабочую директорию
COPY package.json package-lock.json ./

# устанавливаем указанные зависимости NPM на этапе установки образа
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
EXPOSE 8080

# запускаем основной скрипт в момент запуска контейнера
CMD npm run serve:prod

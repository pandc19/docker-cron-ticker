# /app /usr /lib
# FROM --platform=linux/amd64 node:19.2-alpine3.16
# FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16

# Dependencias de desarrollo
FROM node:19.2-alpine3.16 as deps
# cd app
WORKDIR /app
# Dest /app
COPY package.json ./
# Instalar las dependencias
RUN npm install



# Build y Tests
FROM node:19.2-alpine3.16 as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
# Dest /app
COPY . .
# Realizar testing
RUN npm run test



# Dependencias de producción
FROM node:19.2-alpine3.16 as prod-deps
WORKDIR /app
COPY package.json ./
# Únicamente las dependencias de prod
RUN npm install --prod



# Ejecutar la APP
FROM node:19.2-alpine3.16 as runner
WORKDIR /app
COPY --from=prod-deps /app/node_modules ./node_modules
COPY app.js ./
COPY tasks/ ./tasks
# comando run de la imágen
CMD [ "node", "app.js" ]


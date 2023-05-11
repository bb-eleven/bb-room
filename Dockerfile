FROM node:18 AS build

COPY package*.json ./

RUN npm ci --ignore-scripts

COPY . .
RUN npm run build

FROM node:18-alpine
COPY --from=build /build .
COPY --from=build package.json package.json

EXPOSE 3000
CMD ["node", "index"]
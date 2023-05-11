ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_ANON_KEY

FROM node:18 AS build
ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_ANON_KEY

COPY package*.json ./

RUN npm ci --ignore-scripts

COPY . .

RUN echo $VITE_SUPABASE_URL >> .env.production 
RUN echo $VITE_SUPABASE_ANON_KEY >> .env.production
RUN npm run build

FROM node:18-alpine
COPY --from=build /build .
COPY --from=build package.json package.json

EXPOSE 3000
CMD ["node", "index"]
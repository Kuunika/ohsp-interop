FROM node:14 as builder

WORKDIR /app

COPY package*.json ./

RUN npm install --only=prod

COPY . .

RUN npm install -g rimraf 

RUN npm run build


FROM node:15.8.0-alpine3.10

ARG OHSP_BASE_URL
ARG OHSP_USERNAME
ARG OHSP_PASSWORD
ARG COVID_DASHBOARD_API_URL

ENV OHSP_BASE_URL=$OHSP_BASE_URL
ENV OHSP_USERNAME=$OHSP_USERNAME
ENV OHSP_PASSWORD=$OHSP_PASSWORD
ENV COVID_DASHBOARD_API_URL=$COVID_DASHBOARD_API_URL

WORKDIR /app

COPY --from=builder /app ./

RUN npm install pm2 -g

CMD ["pm2-runtime","dist/main.js"]

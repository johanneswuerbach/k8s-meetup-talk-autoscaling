FROM node:12-alpine

WORKDIR /app

COPY package.json package-lock.json ./

RUN npm ci

COPY index.js ./

CMD [ "node", "index.js" ]

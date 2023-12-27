FROM node:20.10.0-alpine3.19
LABEL maintainer="Taen Ahammmed"
LABEL email="taenahammed7@gmail.com"

WORKDIR /app
COPY package*.json .
RUN npm i
COPY . .
EXPOSE 3000

CMD ["npm", "start"]
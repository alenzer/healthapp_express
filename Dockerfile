FROM node:15-alpine3.10 as build
ENV NODE_ENV production
LABEL version="1.1"
LABEL description="This is the base docker image for prod Backend react app."

WORKDIR /app

COPY ["package.json", "./"]

RUN npm install

COPY . ./

EXPOSE 8000
CMD ["npm", "start"]
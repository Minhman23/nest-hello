#Build 
FROM node:18-alphine AS build 

WORKDIR /usr/src/app

COPY package*.json ./

RUN yarn install

COPY . .

RUN yarn build

#Prod Stage
FROM node:18-alphine 

WORKDIR /usr/src/app

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY --from=build /usr/src/app/dist ./dist

COPY package*.json ./

RUN yarn --only=production

RUN rm package*.json

EXPOSE 3000

CMD [ "node", "dist/main.js" ]
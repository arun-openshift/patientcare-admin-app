FROM node:alpine as uibuilder
RUN apk update
WORKDIR /app
COPY package.json /app/
RUN npm install @angular/cli -g
RUN cd /app && npm install
COPY .  /app
RUN cd /app && ng build --prod

FROM nginx
RUN rm -rf /usr/share/nginx/html/*
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=uibuilder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
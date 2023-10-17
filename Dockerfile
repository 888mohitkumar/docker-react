FROM node:16-alpine as builder 

# with as we are giving the name to this phase like builder is the name of this phase.

WORKDIR '/app'

#This copy is used because package.json have dependency list and after that we run npm install so that we can down load that dependency.
COPY package.json .


RUN npm install

#[eslint] EACCES: permission denied, mkdir '/app/node_modules/.cache'
#ERROR in [eslint] EACCES: permission denied, mkdir '/app/node_modules/.cache'
# Due to above error below line was added . ABove error during running>  docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app 6c45758f5ccc
RUN mkdir node_modules/.cache && chmod -R 777 node_modules/.cache

# this is use to copy the source code from curret working dir to /app folder
COPY . .


#Builds a production version of the application
RUN npm run build

#Below we are starting the new phase ....

FROM nginx

# copy from builder phase . copy from "/app/build" location from above phase to location /usr/share/nginx/html in nginx.
# in above pahse source code was build and was put on /app/build location and here we are copying that build folder structure in nginx floder structure.
COPY --from=builder /app/build /usr/share/nginx/html
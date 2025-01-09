# Create the node stage
FROM node:latest as builder

#Set the working directory
WORKDIR /app

#Copy from the currect directory to working directory
COPY . .

#Run npm install & build application
RUN npm install && npm run ng build

#Create the nginx stage for the serving the content
FROM nginx:alphine

#Set the working directory to nginx assets directory
WORKDIR /usr/share/nginx/html

#Remove the default nginx static files
RUN rm -rf ./*

#Copy the static content from builder stage
COPY --from=builder /app/dist/web-vfd-reports

#Container run the nginx with global directive and Daemon off
ENTRYPOINT ["nginx","-g","daemon off"]
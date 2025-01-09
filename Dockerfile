# Stage 1: Build Angular App
FROM node:latest as builder

# Set the working directory for the Node.js build stage
WORKDIR /app

# Copy the entire project to the container
COPY . .

# Install dependencies and build the Angular application
RUN npm install && npm run build --prod

# Stage 2: Serve the Angular app using Nginx
FROM nginx:alpine

# Set the working directory to Nginx's default web directory
WORKDIR /usr/share/nginx/html

# Remove default Nginx static files (if any)
RUN rm -rf ./*

# Copy the built Angular app from the builder stage
COPY --from=builder /app/dist/web-vfd-reports/ .

# Expose the default HTTP port
EXPOSE 80

# Start Nginx in the foreground
ENTRYPOINT ["nginx", "-g", "daemon off;"]

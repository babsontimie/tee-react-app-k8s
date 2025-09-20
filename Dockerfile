# -------- Stage 1: Build React app --------
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Install dependencies (only package.json + lock first for better cache)
COPY tee-react-app/package*.json ./
RUN npm ci --legacy-peer-deps

# Copy source code
COPY tee-react-app/ .

# Build production version
RUN npm run build

# -------- Stage 2: Nginx serve --------
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy build output to Nginx
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom Nginx config (optional, if you need SPA routing)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]

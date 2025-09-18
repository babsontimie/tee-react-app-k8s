# ---- Build stage ----

FROM node:20   AS build

# Set working directory inside the container
WORKDIR /app

# Copy only package.json + lock file first (better layer caching)
COPY tee-react-app/ package*.json ./

# Install dependencies

RUN npm ci 

# Copy rest of the app

COPY tee-react-app/ . 

# Build the React app
RUN npm run build


# ---- Production stage ----
FROM nginx:alpine

COPY --from=build /app/build  /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]


#CMD [ "npm", "start" ]

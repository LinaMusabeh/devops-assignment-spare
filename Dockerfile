# using a small image as the base, using an appropriate tag
FROM node:18-alpine

# alpine by default only has a root user, so we are creating another one with less privileges 
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# creating a working directory inside the image 
WORKDIR /app

# copying the manifest first, to minimize the time of each layer
COPY package*.json ./

# installing dependencies in a separate layer, before copying source
RUN npm ci --omit=dev

# copying the actual application code
COPY src ./src

# using the non-root user before running the app
USER appuser

ENV PORT=8080
EXPOSE 8080

# the actual run of the app, not using npm to make it one process 
CMD ["node", "src/index.js"]
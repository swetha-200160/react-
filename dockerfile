# 1. Use Node image
FROM node:18-alpine

# 2. Set working directory
WORKDIR /app

# 3. Copy package files
COPY package*.json ./

# 4. Install dependencies (IMPORTANT FIX)
RUN npm install --legacy-peer-deps

# 5. Copy source code
COPY . .

# 6. Expose React port
EXPOSE 3000

# 7. Start React app
CMD ["npm", "start"]

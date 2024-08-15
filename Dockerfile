FROM node:latest
WORKDIR /app
COPY . .
RUN npm install
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build
ENV NODE_OPTIONS=--openssl-legacy-provider
EXPOSE 3000
CMD ["npm", "run", "dev"]

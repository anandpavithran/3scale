FROM registry.redhat.io/rhel9/nodejs-22
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY app.js ./
EXPOSE 8080
CMD ["npm", "start"]

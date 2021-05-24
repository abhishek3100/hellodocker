#using official node runtime
FROM node:6

#setting working directory to /app
WORKDIR /app

#copy the current directory's content to /app directory
ADD . /app

#making the container port available to outside 
EXPOSE 80

#running app when container start
CMD ["node", "app.js"]
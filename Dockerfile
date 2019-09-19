FROM node:8

LABEL version="1.0.0" \ 
      maintainer="leeyxq@gmail.com"
      
ENV EASY_MOCK_VERSION 1.6.0

WORKDIR /root/easy_mock

VOLUME /data

# 安装mongodb、redis、easy-mock
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
      echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" | tee /etc/apt/sources.list.d/mongodb-org-4.0.list && \
      apt-get update && \
      mkdir -p /data/monogo && \
      mkdir -p /data/redis && \
      apt-get install -y mongodb-org redis-server && \
      wget --no-check-certificate -O easy_mock.tar.gz https://github.com/easy-mock/easy-mock/archive/v${EASY_MOCK_VERSION}.tar.gz && \
      tar -xzvf easy_mock.tar.gz --strip-components 1 && \
      rm -f easy_mock.tar.gz && \
      yarn install && \
      yarn run build && \
      yarn global add pm2 && \
      yarn cache clean && \
      printf "mongod --bind_ip_all --fork --logpath /data/monogo/monogo.log --dbpath /data/monogo \n redis-server --protected-mode no --daemonize yes --logfile /data/redis/redis.lg --dir /data/redis  \n pm2-docker start app.js" > /start-all.sh && \
      chmod a+x /start-all.sh
 
 EXPOSE 8033

 CMD ["sh", "-c", "/start-all.sh"]
 

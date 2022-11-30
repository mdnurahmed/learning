# docker-gs-ping


## single stage 
docker build --tag docker-gs-ping .
docker image ls
docker image tag docker-gs-ping:latest docker-gs-ping:v1.0
docker image ls

# multistage 
docker build -t docker-gs-ping:multistage -f Dockerfile.multistage .
docker image ls
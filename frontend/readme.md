docker build -t frontend:v1 -f Dockerfile .     

docker image tag frontend:v1 nurahmedsabbir/frontend:v1


docker push nurahmedsabbir/frontend:v1


❯ docker run -p 7070:7070 frontend:v1


npm install -g yaml-lint
yamllint k8.yaml
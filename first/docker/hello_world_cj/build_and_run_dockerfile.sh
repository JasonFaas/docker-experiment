aws ecr get-login-password | docker login --username AWS --password-stdin 753699122647.dkr.ecr.us-west-2.amazonaws.com

aws ecr describe-repositories | rg -i "repo.*name.*jnf/docker-first"

docker build -t 753699122647.dkr.ecr.us-west-2.amazonaws.com/jnf/docker-first:latest .
docker push 753699122647.dkr.ecr.us-west-2.amazonaws.com/jnf/docker-first:latest

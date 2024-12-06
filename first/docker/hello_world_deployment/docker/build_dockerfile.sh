aws ecr get-login-password | docker login --username AWS --password-stdin 753699122647.dkr.ecr.us-west-2.amazonaws.com

aws ecr describe-repositories | rg -i "repo.*name.*jnf/flask-hello-world"

# Build the Docker image
docker build -t flask-hello-world .

# Tag the image for your container registry (example for Docker Hub)
docker tag flask-hello-world 753699122647.dkr.ecr.us-west-2.amazonaws.com/jnf/flask-hello-world:latest

# Push the image
docker push 753699122647.dkr.ecr.us-west-2.amazonaws.com/jnf/flask-hello-world:latest

echo ""
echo "Docker built successfully and pushed to ECR"

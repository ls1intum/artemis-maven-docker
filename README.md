# artemis-maven-template

This also includes git and replaces https://github.com/ls1intum/artemis-maven-git-docker.

Docker Container for Docker Hub

	docker build --no-cache -t artemis-maven-template .

	docker run -itd -p 80:80 --name artemis-maven-template artemis-maven-template /bin/bash

	docker exec -it artemis-maven-template /bin/bash

	java -version
	
	mvn -version
	
	git --version
	
	
### Publish to Dockerhub

	docker buildx build --no-cache -t ls1tum/artemis-maven-template:<tagname> . --push --platform=linux/arm64,linux/amd64	
	
#### Example

	docker buildx build --no-cache -t ls1tum/artemis-maven-template:java17-9 . --push --platform=linux/arm64,linux/amd64	

#### Github Action

Note that each commit will automatically lead to a new image on DockerHub using the `latest` tag.
Creating a release (with a unique tag) will automatically create a new image on DockerHub using the tag name.

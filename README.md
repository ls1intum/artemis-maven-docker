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

	docker buildx build --no-cache -t ls1tum/artemis-maven-template:java25-1 . --push --platform=linux/arm64,linux/amd64	

#### Github Action

Note that each commit will automatically lead to a new image on DockerHub using the `latest` tag.
Creating a release (with a unique tag) will automatically create a new image on DockerHub using the tag name.

#### Cached Artemis templates

The directory `artemis-templates` contains the test repositories (including a solution) that Artemis generates for Java (Maven, Gradle) and Kotlin (Maven) programming exercises.
The Dockerfile builds them once so that their dependencies and plugins (including the transitive dependencies of Ares 2) are part of the image and builds on Artemis do not need to download them.
When the templates in Artemis change (e.g. new dependency versions), render them again and replace the content of this directory.

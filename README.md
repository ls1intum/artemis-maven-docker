# artemis-maven-docker

This also includes git and replaces https://github.com/ls1intum/artemis-maven-git-docker.

Docker Container for Docker Hub

	docker build --no-cache -t artemis-maven-docker .

	docker run -itd -p 80:80 --name artemis-maven-docker artemis-maven-docker /bin/bash

	docker exec -it artemis-maven-docker /bin/bash

	java -version
	
	mvn -version
	
	git --version
	
	
### Publish to Dockerhub

	docker build --no-cache -t ls1tum/artemis-maven-docker:<tagname> .

	docker push ls1tum/artemis-maven-docker:<tagname>
	
	
	
#### Example

	docker build --no-cache -t ls1tum/artemis-maven-docker:java16-5 .
	
	docker push ls1tum/artemis-maven-docker:java16-5

	
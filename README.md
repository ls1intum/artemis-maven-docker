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

	docker build --no-cache -t ls1tum/artemis-maven-template:<tagname> .

	docker push ls1tum/artemis-maven-template:<tagname>
	
	
	
#### Example

	docker build --no-cache -t ls1tum/artemis-maven-template:java16-5 .
	
	docker push ls1tum/artemis-maven-template:java16-5

	
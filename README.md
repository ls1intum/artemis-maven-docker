# artemis-maven-docker

This also includes git and replaces https://github.com/ls1intum/artemis-maven-git-docker.

Docker Container for Docker Hub

	docker build --no-cache -t artemis-maven-docker .

	docker run -itd -p 80:80 --name artemis-maven-docker artemis-maven-docker

	docker exec -it artemis-maven-docker /bin/bash

	java -version

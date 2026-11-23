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

#### Keep the image in sync with Artemis

`artemis-java-template/pom.xml` and `build.gradle` hold the plugins and dependencies that are cached in the image. When the Java test templates
in `src/main/resources/templates/java` of Artemis pin other versions (Ares, Guava, the static code analysis plugins, ...), every build of an
exercise downloads the difference. Artemis enforces this: `supporting_scripts/check_exercise_image_sync.py` compares the templates with these files at
the tag configured in `application.yml` on every pull request, and a nightly run builds the Java exercise templates in the published image without
network access (`supporting_scripts/verify_exercise_images_offline.py`). After a change here, create a new release (tag) and set it in `application.yml`.

#### Vulnerable transitive dependencies

Several Maven plugins and Ares bring old versions of libraries with them (e.g. `commons-beanutils`, `plexus-utils`, `snappy`, Guava). The plugins in
`pom.xml` therefore override them in their `<dependencies>`, and `dependencyManagement` (Maven) and `constraints` (Gradle) do the same for the Ares tree.
The Artemis templates carry the same overrides. `ares-resolve/pom.xml` resolves Ares the way an exercise does (only Guava and `commons-beanutils`
managed), so that the vulnerable versions Ares brings are not cached either. To check an image, scan it, e.g.
`docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy image --scanners vuln <image>`.
Left as they are: the Guava of the Maven distribution in the base image and the one bundled inside the Checker Framework, which only run while the image is built.

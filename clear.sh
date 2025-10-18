#!/bin/sh
docker stop test
docker rm test
docker rmi auska/docker-aria2:1.37.0-2
docker build -t auska/docker-aria2:1.37.0-2 .
docker run -d --restart unless-stopped --name test -p 6801:6800 -p 16881:16881 -p 8080:80 auska/docker-aria2:1.37.0-2

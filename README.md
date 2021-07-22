This repository contains Dockerfiles which will install all dependencies needed to build [Performous](https://github.com/performous/performous/wiki/Building-and-installing-from-source).  

These containers are to be used as `base images` to provide higher-level builds and packages and to produce artifacts for downstream consumption. These containers **do not** provide a running version of `Performous` or contain the project source in any usable form.  

## Building containers
The build is a pretty standard `docker build`, just make sure you explicitly call out a `Dockerfile` with `-f Dockerfile.<distro.version>`:  
```sh
docker build -t performous-docker-build:ubuntu20.04 -f Dockerfile.ubuntu20.04 .
```

## Running the containers
Once the `base-image` has been built, the container can be run interactively to build `Performous`:  
```sh
docker run -it performous-docker-build:ubuntu20.04
```  

From there, you can [follow the build instructions](https://github.com/performous/performous/wiki/Building-and-installing-from-source#downloading-and-installing-the-sources) to build performous.  


`build_performous.sh` is included in the containers mostly for testing purposes. By default the script will build the master branch of [the performous repo](https://github.com/performous/performous). If run with a number as an argument, it will build the pull request associated with that number. This can be added as argument to the `docker run` to run a build when the container is spawned:  
```
docker run performous-docker-build:ubuntu20.04 ./build_performous.sh 626
```

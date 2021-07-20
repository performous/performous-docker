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

```

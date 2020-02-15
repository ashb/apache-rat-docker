# Apache Rat in a small docker container

This repo aims to put [Apache Rat](https://creadur.apache.org/rat/) into a tiny
Docker image.

It is auto-built by Docker hub.

## Usage

```
docker run --rm -t  \
  -v /path/to/src:/to-check \
  -- \
  ashb/apache-rat \
  --exclude-file /to-check/.rat-excludes \
  --dir /to-check
```

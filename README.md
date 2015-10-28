
This is a Docker image to help you develop in Go (golang). The great thing is you don't need
to have anything installed except Docker, you don't even need Go installed. See [this post about developing with Docker](https://medium.com/iron-io-blog/why-and-how-to-use-docker-for-development-a156c1de3b24).

This image can perform the following functions:

* vendor - vendors your dependencies into a /vendor directory.
* build - builds your program using the vendored dependencies, with no import rewriting.
* remote - this one will produce a binary from a GitHub repo. Equivalent to cloning, vendoring and building.
* image - this will build and create a Docker image out of your program.
* cross - cross compile your program into a variety of platforms. Based on [this](https://medium.com/iron-io-blog/how-to-cross-compile-go-programs-using-docker-beaa102a316d#95d9).
* static - statically compile your program. This is great for making the [tiniest Docker image possible](http://www.iron.io/blog/2015/07/an-easier-way-to-create-tiny-golang-docker-images.html).

## Usage

The usage is the same for all languages, that's the beauty of this!

First, to simplify things, add this to your bashrc:

```
dj() {
  docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -v $HOME:/root:ro -w /app -p 8080:8080 devo/dj $@
}
```

### ALL languages

Replace the language of your choice in the commands below from this list:

* go
* ruby
* node
* php
* python

Here are the main commands you'll use:

```sh
# vendor
dj LANG vendor
# test
dj LANG run [script.abc]
# build Docker image
dj LANG image username/myapp:latest
# test image
docker run --rm -p 8080:8080 username/myapp [script.abc]
# push image to docker hub
docker push username/myapp
```

`script.abc` is for interpreted languages, for example: `dj ruby run hello.rb`

### Go specific commands

```sh
# build, run already does this, but if you just want to build without running:
dj go build
# fmt
dj go fmt
# Build static binary
dj go static
```

### Ruby:

NOTE: You must add `require_relative 'bundle/bundler/setup'` to the start of Ruby program/script.

```sh
# run
dj ruby run hello.rb
# build image - hello.rb on the end is the script to run
dj ruby image username/rubyapp:latest hello.rb
```

### Node:

Nothing special.

### Python:

Nothing special.

### PHP:

Nothing special.





## Troubleshooting

TODO:

## To Do

* [ ] Add more languages. Help wanted!


## Building this image

```sh
docker build -t devo/dj:latest .
```

Tag it with the version:

```sh
docker tag devo/dj:latest devo/dj:$(cat version.txt)
```

Push:

```sh
docker push devo/dj
```

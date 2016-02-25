# Docker Jockey

![Jockey](http://i.giphy.com/5iDijZZe6RzYQ.gif)

**All you need is Docker!**

This is a Docker image that will enable you to develop in all your favorite languages and all you need to install is Docker.
You don't need to install any language runtimes or environment, just run the commands below and it will **just work**.

This image was inspired by [this post about developing with Docker](https://medium.com/iron-io-blog/why-and-how-to-use-docker-for-development-a156c1de3b24).

The following commands are the main commands, and they are the same for all languages:

* vendor - vendors your dependencies into a /vendor directory.
* build - builds your program using the vendored dependencies
* run - runs your program
* image - this will build and create a Docker image out of your program

See below for more details on these commands.

## Install

It's packaged as a gem, so just run:

```sh
gem install dj2
```

## Usage

The usage is the same for all languages, that's the beauty of this!

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
# check language version
dj LANG version
```

`script.abc` is for interpreted languages, for example: `dj ruby run hello.rb`

### Port mapping

So you can map ports from the Docker containers to your app.

Similar to Docker, use `-p` after `dj`, example:

```sh
dj -p "8080:8080" ruby run hello.rb
```

### Environment Variables

Similar to Docker, use `-e` after `dj`, example:

```sh
dj -e "MYENVVAR=YO" ruby run hello.rb
```

### Language Specific Commands

#### Go specific commands

```sh
# build, run already does this, but if you just want to build without running:
dj go build
# fmt:
dj go fmt
# Build static binary. This is great for making the [tiniest Docker image possible](http://www.iron.io/blog/2015/07/an-easier-way-to-create-tiny-golang-docker-images.html):
dj go static
# Cross compile your program into a variety of platforms (based on [this](https://medium.com/iron-io-blog/how-to-cross-compile-go-programs-using-docker-beaa102a316d#95d9):
dj go cross
# Build remote repo: this one will produce a binary from a GitHub repo. Equivalent to cloning, vendoring and building
dj go remote http://github.com/org/project
```

#### Ruby:

NOTE: You must add `require_relative 'bundle/bundler/setup'` to the start of Ruby program/script.

```sh
# run
dj ruby run hello.rb
# build image - hello.rb on the end is the script to run
dj ruby image username/rubyapp:latest hello.rb
```

#### Node:

```sh
# run npm commands like npm start
dj node npm start
```

#### Python:

Nothing special.

#### PHP:

Nothing special.

## Examples with various languages

You can use the code in this repo for examples: https://github.com/iron-io/dockerworker

## Git

Just like git!

```sh
dj git COMMAND
```

Authentication? see: http://stackoverflow.com/questions/11403407/git-asks-for-username-everytime-i-push

Can keep your username and password:

```sh
dj git config --global credential.helper store
```


## To Do

See: https://github.com/treeder/devo/issues

## Troubleshooting

First, enable debugging by adding `-e "LOG_LEVEL=DEBUG"` to your dj docker run command.

## Building Gem

```sh
bundle install
```


## Building as a Docker image

Vendor gems:

```sh
docker run --rm -v "$PWD":/worker -w /worker iron/ruby:dev bundle install --standalone --clean
```

Testing:

```sh
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -v "$HOME":/root -w /app -e "LOG_LEVEL=DEBUG" treeder/ruby-dind ruby bin/dj COMMAND
```

Build image:

```sh
docker build -t treeder/dj:latest .
```

Tag it with the version:

```sh
docker tag treeder/dj:latest treeder/dj:$(cat version.txt)
```

Push:

```sh
docker push treeder/dj
```

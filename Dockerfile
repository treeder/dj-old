# If not using dind, let's replace with iron/ruby
FROM treeder/ruby-dind

RUN apk update && apk upgrade

RUN apk add mercurial

# Clean APK cache
RUN rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

ADD . /scripts/

ENTRYPOINT ["ruby", "/scripts/lib/main.rb"]

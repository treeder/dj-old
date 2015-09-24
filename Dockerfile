# If not using dind, let's replace with iron/ruby
FROM treeder/ruby-dind

RUN mkdir /app
WORKDIR /app

#ADD start.sh /scripts/
#ADD main.sh /scripts/
ADD . /scripts/
#ADD lib/* /scripts/lib/


# Default is to update and install dependencies
# dind:
#ENTRYPOINT ["sh", "/scripts/start.sh"]
# callout:
ENTRYPOINT ["ruby", "/scripts/main.rb"]

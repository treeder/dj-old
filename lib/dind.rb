# This has helpers for running this inside a container - docker in docker
module DockerJockey

  # Gets volumes for parent container to be used in sub containers
  def self.find_volumes
    @volumes = "-v \"#{Dir.pwd}\":/app"
    begin
      puts "inspect: #{`docker inspect`}"
      di = JSON.parse("#{`docker inspect $HOSTNAME`}")
      # p di
      @volumes = "--volumes-from #{di[0]['Name']}"
      DockerJockey.docker_host = di[0]
    rescue => ex
      p ex
      puts "couldn't inspect"
    end

    if ARGV.length < 1
      DockerJockey.logger.fatal "No command provided."
      exit
    end

    # DockerJockey.logger.debug "Options: #{options.inspect}"

    DockerJockey.volumes = @volumes
  end
end

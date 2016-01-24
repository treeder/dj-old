
module DockerJockey
  class GitHelper

    def run(args, options)
      DockerJockey.logger.debug args
      DockerJockey.logger.debug options
      # Just passing this along to git
      DockerJockey.docker_exec("treeder/git", args, options)
    end
  end
end


module Devo
  class GitHelper

    def run(args, options)
      Devo.logger.debug args
      Devo.logger.debug options
      # Just passing this along to git
      Devo.docker_exec("treeder/git", args, options)
    end
  end
end

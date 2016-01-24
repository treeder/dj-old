
module DockerJockey
  class NodeHelper

    def run(args, options)
      if args.length < 1
        raise "devo node: invalid args."
      end
      case args[0]
      when 'run'
        DockerJockey.docker_exec("iron/node", "node #{args[1]}", options)
      when 'install', 'vendor'
        # npm install
        DockerJockey.docker_exec("iron/node:dev", "npm install", options)
        DockerJockey.exec("chmod -R a+rw node_modules")
      when 'npm'
        DockerJockey.docker_exec("iron/node:dev", "npm #{args[1]}", options)
      when 'image'
        DockerJockey::ImageHelper.build1('iron/node', 'node', args[1..args.length])
      when 'version'
        DockerJockey.docker_exec("iron/node", "node -v")
      else
        raise "Invalid node command: #{args[0]}"
      end
    end
  end
end


module DockerJockey
  class PhpHelper

    def run(args, options)
      if args.length < 1
        raise "devo php: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        DockerJockey.docker_exec("iron/php:dev", "composer install", options)
        DockerJockey.exec("chmod -R a+rw vendor")
      when 'run'
        DockerJockey.docker_exec("iron/php", "php #{args[1]}", options)
      when 'image'
        DockerJockey::ImageHelper.build1('iron/php', 'php', args[1..args.length])
      when 'version'
        DockerJockey.docker_exec("iron/php", "php -v", options)
      else
        raise "Invalid php command: #{args[0]}"
      end

    end

  end
end

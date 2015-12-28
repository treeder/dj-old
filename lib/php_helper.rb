
module Devo
  class PhpHelper

    def run(args, options)
      if args.length < 1
        raise "devo php: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        Devo.docker_exec("iron/php:dev", "composer install", options)
        Devo.exec("chmod -R a+rw vendor")
      when 'run'
        Devo.docker_exec("iron/php", "php #{args[1]}", options)
      when 'image'
        Devo::ImageHelper.build1('iron/php', 'php', args[1..args.length])
      when 'version'
        Devo.docker_exec("iron/php", "php -v", options)
      else
        raise "Invalid php command: #{args[0]}"
      end

    end

  end
end

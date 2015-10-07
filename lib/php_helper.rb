
module Devo
  class PhpHelper

    def run(args)
      if args.length < 1
        raise "devo php: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        Devo.docker_exec("iron/php:dev", "composer install")
        Devo.exec("chmod -R a+rw vendor")
      when 'image'
        Devo::ImageHelper.build1('iron/php', 'php', args[1..args.length])
      else
        raise "Invalid php command: #{args[0]}"
      end

    end

  end
end

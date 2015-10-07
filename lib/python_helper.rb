
module Devo
  class PythonHelper

    def run(args)
      if args.length < 1
        raise "devo python: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        Devo.docker_exec("iron/python:dev", "pip install -t packages -r requirements.txt")
        Devo.exec("chmod -R a+rw packages")
      when 'image'
        Devo::ImageHelper.build1('iron/python', 'python', args[1..args.length])
      else
        raise "Invalid python command: #{args[0]}"
      end

    end

  end
end


module Devo
  class PythonHelper

    def run(args, options)
      if args.length < 1
        raise "devo python: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        Devo.docker_exec("iron/python:2-dev", "pip install -t packages -r requirements.txt", options)
        Devo.exec("chmod -R a+rw packages")
      when 'run'
        Devo.docker_exec("iron/python:2", "python #{args[1]}", options)
      when 'image'
        Devo::ImageHelper.build1('iron/python:2', 'python', args[1..args.length])
      when 'version'
        Devo.docker_exec("iron/python:2", "python --version".split(' '), options)
      else
        raise "Invalid python command: #{args[0]}"
      end

    end

  end
end

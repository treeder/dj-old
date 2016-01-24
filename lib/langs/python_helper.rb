
module DockerJockey
  class PythonHelper

    def run(args, options)
      if args.length < 1
        raise "devo python: invalid args."
      end
      case args[0]
      when 'install', 'vendor'
        # npm install
        DockerJockey.docker_exec("iron/python:2-dev", "pip install -t packages -r requirements.txt", options)
        DockerJockey.exec("chmod -R a+rw packages")
      when 'run'
        DockerJockey.docker_exec("iron/python:2", "python #{args[1]}", options)
      when 'image'
        DockerJockey::ImageHelper.build1('iron/python:2', 'python', args[1..args.length])
      when 'version'
        DockerJockey.docker_exec("iron/python:2", "python --version".split(' '), options)
      else
        raise "Invalid python command: #{args[0]}"
      end

    end

  end
end

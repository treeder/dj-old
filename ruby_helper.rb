require 'fileutils'

module Devo
  class RubyHelper
    def image(args=[])
      if args.length < 2
        puts "devo: image command requires image name and ruby script to run."
        raise "devo: image command requires image name and ruby script to run."
      end
      FileUtils.mkdir_p '/tmp/app'
      Devo.exec("cp -r . /tmp/app")
      # exec("cp /scripts/lib/Dockerfile /tmp/app")
      File.open('/tmp/app/Dockerfile', 'w') { |file|
        file.write("FROM iron/ruby
        WORKDIR /app
        COPY . /app/
        ENTRYPOINT [\"ruby\", \"#{args[1]}\"]
        ")
      }
      Devo.exec("ls -al /tmp/app")
      FileUtils.cd('/tmp/app') do
        Devo.exec("/usr/bin/docker version")
        Devo.exec("/usr/bin/docker build -t #{args[0]} .")
      end
    end
  end
end

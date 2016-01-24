require 'fileutils'

module DockerJockey
  class ImageHelper
    def self.build1(from, entry, args)
      if args.length < 1
        raise "devo: image command requires image name and filename of script to run."
      end
      image_name = args[0]
      filename = args[1]
      FileUtils.mkdir_p '/tmp/app'
      DockerJockey.exec("cp -r . /tmp/app")
      entrypoint = [entry]
      entrypoint << filename if filename
      # exec("cp /scripts/lib/Dockerfile /tmp/app")
      File.open('/tmp/app/Dockerfile', 'w') { |file|
        file.write("FROM #{from}
        WORKDIR /app
        COPY . /app/
        ENTRYPOINT [ #{entrypoint.map{ |e| '"' + e + '"'}.join(', ') }  ]
        ")
      }
      # DockerJockey.exec("cat /tmp/app/Dockerfile")
      # DockerJockey.exec("ls -al /tmp/app")
      FileUtils.cd('/tmp/app') do
        DockerJockey.exec("/usr/bin/docker version")
        DockerJockey.exec("/usr/bin/docker build -t #{image_name} .")
      end
    end
  end
end

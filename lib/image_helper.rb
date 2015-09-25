module Devo
  class ImageHelper
    def self.build1(from, entry, args)
      if args.length < 2
        raise "devo: image command requires image name and filename of script to run."
      end
      image_name = args[0]
      filename = args[1]
      FileUtils.mkdir_p '/tmp/app'
      Devo.exec("cp -r . /tmp/app")
      # exec("cp /scripts/lib/Dockerfile /tmp/app")
      File.open('/tmp/app/Dockerfile', 'w') { |file|
        file.write("FROM #{from}
        WORKDIR /app
        COPY . /app/
        ENTRYPOINT [\"#{entry}\", \"#{filename}\"]
        ")
      }
      Devo.exec("ls -al /tmp/app")
      FileUtils.cd('/tmp/app') do
        Devo.exec("/usr/bin/docker version")
        Devo.exec("/usr/bin/docker build -t #{image_name} .")
      end
    end
  end
end

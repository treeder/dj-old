require 'fileutils'

module DockerJockey
  class ImageHelper
    def self.build1(from, entry, args)
      if args.length < 1
        raise "devo: image command requires image name and filename of script to run."
      end
      image_name = args[0]
      filename = args[1]
      # tmpdir = 'tmp/app'
      # FileUtils.mkdir_p tmpdir
      # DockerJockey.exec("cp -r . #{tmpdir}")
      entrypoint = [entry]
      entrypoint << filename if filename
      # exec("cp /scripts/lib/Dockerfile /tmp/app")
      dockerfile = "__Dockerfile__"
      File.open(dockerfile, 'w') { |file|
        file.write("FROM #{from}
        WORKDIR /app
        COPY . /app/
        ENTRYPOINT [ #{entrypoint.map{ |e| '"' + e + '"'}.join(', ') }  ]
        ")
      }
      # DockerJockey.exec("cat /tmp/app/Dockerfile")
      # DockerJockey.exec("ls -al /tmp/app")
      # FileUtils.cd(tmpdir) do
        DockerJockey.exec("docker version")
        DockerJockey.exec("docker build -t #{image_name} -f #{dockerfile} .")
      # end
      File.delete(dockerfile)

    end
  end
end

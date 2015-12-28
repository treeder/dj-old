
module Devo

  def self.docker_exec(image, args, options)
    docker_run(image, args, options)
  end

  def self.docker_exec_script(image, script, options)
    # TODO: change this to use docker api, like docker exec
    # write script and mount inside container
    File.write('__uberscript__', script)
    args = "chmod a+x __uberscript__ && ./__uberscript__"
    docker_run(image, args, options)
    File.delete('__uberscript__')
  end

  def self.docker_run(image, args, options=OpenStruct.new)
    # mounts = Devo.docker_host[]
    Devo.logger.debug("docker_exec args: #{args.inspect}")
    coptions = {
      'Image' => image,
      'Cmd' => ['sh', '-c', "#{args}"],
      "AttachStdout": true,
      "AttachStderr": true,
      # 'Mounts' => mounts,
      # "Env": [
              #  "FOO=bar",
              #  "BAZ=quux"
      #  ],
      'WorkingDir' => '/app',
      "HostConfig" => {
        'VolumesFrom' => [Devo.docker_host['Name']],
        "Binds": Devo.docker_host['HostConfig']['Binds']
      },
    }
    if options.env_vars && options.env_vars.length > 0
      coptions['Env'] = options.env_vars
    end
    # puts "container options:"
    # p coptions
    container = Docker::Container.create(coptions)
    container.tap(&:start).streaming_logs(follow:true, stdout: true, stderr: true) { |stream, chunk|
      # puts "#{stream}: #{chunk}" # for debugging
      puts chunk
    }
    # container.tap(&:start).streaming_logs(stdout: true, stderr: true) { |stream, chunk| puts "#{stream}: #{chunk}" }
    # container.tap(&:start).attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true) { |stream, chunk| puts "#{stream}: #{chunk}" }
    container.delete(:force => true)
  end

  def self.popen(maincmd, cname)
    Open3.popen2e('docker', *(maincmd)) {|i,oe,t|
      pid = t.pid # pid of the started process.
      # puts "pid: #{pid}"
      i.close # ensure this exits when it's done with output

      # Catch interrupts to shut down the docker process too
      Signal.trap("INT") {
        # Ctrl-C was pressed...
        puts "Caught interrupt - killing docker child..."

        # Kill child process...
        p `docker kill #{cname}`
        # Process.kill("INT", pid)

        # This prevents the process from becoming defunct
        # oe.close
      }

      begin
        oe.each {|line|
          if /warning/ =~ line
            puts 'warning'
          end
          puts line
        }
      rescue IOError => ex
        # ignore?  closed stream probably
      end
      oe.close
      exit_status = t.value # Process::Status object returned.
      # puts "exit_status: #{exit_status}"
    }
  end

  def self.exec(cmd, args = [])
    split = cmd.split(' ')
    puts "Exec: #{(split + args).join(' ')}"
    base = split.shift
    Open3.popen2e(base, *(split + args)) {|i,oe,t|
      pid = t.pid # pid of the started process.
      i.close # ensure this exits when it's done with output
      oe.each {|line|
        if /warning/ =~ line
          puts 'warning'
        end
        puts line
      }
      exit_status = t.value # Process::Status object returned.
      # puts "exit_status: #{exit_status}"
    }
  end

end

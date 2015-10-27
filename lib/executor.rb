
module Devo
  @@volumes = nil

  def self.volumes=(x)
    @@foo = x
  end

  def self.volumes
    @@foo
  end

  def self.docker_exec(image, args, options=[])
    maincmd, cname = create_cmd(image, args, options)

    popen(maincmd, cname)

  end

  def self.docker_exec_script(image, options=[], script)
    # write script and mount inside container
    File.write('__uberscript__', script)
    args = "chmod a+x __uberscript__ && ./__uberscript__"
    maincmd, cname = create_cmd(image, args, options)
    popen(maincmd, cname)
    File.delete('__uberscript__')
  end

  def self.popen(maincmd, cname)
    Open3.popen2e('docker', *(maincmd)) {|i,oe,t|
      pid = t.pid # pid of the started process.
      # puts "pid: #{pid}"
      i.close # ensure this exits when it's done with output

      # Catch interrupts to shut down the docker process too
      Signal.trap("INT") {
        # Ctrl-C was pressed...
        puts "Caught interrupt - killing child..."

        # Kill child process...
        p `docker stop #{cname}`
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

  def self.create_cmd(image, args, options)
    name = "dj_#{rand(1000)}"
    # --add-host dockerhost:172.17.42.1 
    maincmd = "run --rm --name #{name} -i #{Devo.volumes} -p 8080:8080 -w /app".split
    options.each do |o|
      maincmd << o
    end
    maincmd << image
    if args.is_a?(String)
#      args = args.split(' ')
    elsif args.is_a?(Array)
      args = args.join(' ')
    end
    maincmd << "sh" << "-c" << args
    puts (maincmd ).join(' ')
    return maincmd, name
  end
end

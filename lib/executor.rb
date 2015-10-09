
module Devo
  @@volumes = nil

  def self.volumes=(x)
    @@foo = x
  end

  def self.volumes
    @@foo
  end

  def self.docker_exec(image, args, options=[])
    maincmd = create_cmd(image, args, options)
    Open3.popen2e('docker', *(maincmd)) {|i,oe,t|
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

  def self.docker_exec_script(image, options=[], script)
    # write script and mount inside container
    File.write('__uberscript__', script)
    args = "chmod a+x __uberscript__ && ./__uberscript__"
    maincmd = create_cmd(image, args, options)
    Open3.popen2e('docker', *(maincmd)) {|i,oe,t|
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
    maincmd = "run --rm -i #{Devo.volumes} -p 8080:8080 -w /app".split
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
    maincmd
  end
end

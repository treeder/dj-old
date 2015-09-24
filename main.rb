require 'open3'
require 'json'
require_relative 'ruby_helper'

# p ARGV
# puts "pwd: #{Dir.pwd}"
# puts "ls: #{`ls -al`}"
@volumes = "-v \"#{Dir.pwd}\":/app"
begin
  # puts "inspect: #{`docker inspect $HOSTNAME`}"
  di = JSON.parse("#{`docker inspect $HOSTNAME`}")
  @volumes = "--volumes-from #{di[0]['Name']}"
rescue => ex
  p ex
  puts "couldn't inspect"
end

if ARGV.length < 1
  puts "No command provided."
end


module Devo
  def self.docker_exec(cmd, args)
    maincmd = "run --rm -i #{@volumes} -w /app".split
    split = cmd.split(' ')
    puts (maincmd + split + args).join(' ')
    Open3.popen2e('docker', *(maincmd + split + args)) {|i,oe,t|
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
end

lang = ARGV.shift
case lang
when 'go'
  Devo.docker_exec "treeder/go", ARGV
when 'ruby'
  helper = Devo::RubyHelper.new
  if ARGV[0] == 'image'
    helper.image(ARGV[1..ARGV.length])
  else
    Devo.docker_exec "treeder/ruby", ARGV
  end
else
  puts "Invalid command, see https://github.com/treeder/dockers/tree/master/go for reference."
end

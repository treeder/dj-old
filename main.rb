require 'open3'
require 'json'
require_relative 'lib/image_helper'
require_relative 'lib/ruby_helper'
require_relative 'lib/node_helper'
require_relative 'lib/python_helper'
require_relative 'lib/php_helper'

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
  @@volumes = nil

  def self.volumes=(x)
    @@foo = x
  end

  def self.volumes
    @@foo
  end

  def self.docker_exec(image, args=[])
    maincmd = "run --rm -i #{Devo.volumes} -w /app".split
    maincmd << image
    if args.is_a?(String)
#      args = args.split(' ')
    end
    maincmd << "sh" << "-c" << args
    puts (maincmd ).join(' ')
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
end

Devo.volumes = @volumes

lang = ARGV.shift
case lang
when 'go'
  Devo.docker_exec "treeder/go", ARGV
when 'ruby'
  helper = Devo::RubyHelper.new
  helper.run(ARGV)
when 'node'
  helper = Devo::NodeHelper.new
  helper.run(ARGV)
when 'python'
  helper = Devo::PythonHelper.new
  helper.run(ARGV)
when 'php'
  helper = Devo::PhpHelper.new
  helper.run(ARGV)
else
  raise "Language not supported."
end

require 'open3'
require 'json'
require_relative 'lib/executor'
require_relative 'lib/image_helper'
require_relative 'lib/ruby_helper'
require_relative 'lib/node_helper'
require_relative 'lib/python_helper'
require_relative 'lib/php_helper'
require_relative 'lib/go_helper'

# p ARGV
# puts "pwd: #{Dir.pwd}"
# puts "ls: #{`ls -al`}"
@volumes = "-v \"#{Dir.pwd}\":/app"
begin
  # puts "inspect: #{`docker inspect $HOSTNAME`}"
  di = JSON.parse("#{`docker inspect $HOSTNAME`}")
  #p di
  @volumes = "--volumes-from #{di[0]['Name']}"
rescue => ex
  p ex
  puts "couldn't inspect"
end

if ARGV.length < 1
  puts "No command provided."
end

Devo.volumes = @volumes

begin
  lang = ARGV.shift
  case lang
  when 'go'
    helper = Devo::GoHelper.new
    helper.run(ARGV)
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
# rescue SystemExit, Interrupt => ex
  # puts "Caught #{ex}"
end

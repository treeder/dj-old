require 'open3'
require 'json'
require 'optparse'
require 'ostruct'
require_relative 'lib/executor'
require_relative 'lib/image_helper'
require_relative 'lib/ruby_helper'
require_relative 'lib/node_helper'
require_relative 'lib/python_helper'
require_relative 'lib/php_helper'
require_relative 'lib/go_helper'

options = OpenStruct.new
x = OptionParser.new do |opt|
  opt.on('-e', '--env ENVVAR', 'An environment variable to pass into container.') { |o|
    options.env_vars = [] unless options.env_vars
    options.env_vars << o
  }
  opt.on('-l', '--last_name LASTNAME', 'The last name') { |o| options.last_name = o }
end
x.parse!
p options

p ARGV
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
    helper.run(ARGV, options)
  when 'ruby'
    helper = Devo::RubyHelper.new
    helper.run(ARGV, options)
  when 'node'
    helper = Devo::NodeHelper.new
    helper.run(ARGV, options)
  when 'python'
    helper = Devo::PythonHelper.new
    helper.run(ARGV, options)
  when 'php'
    helper = Devo::PhpHelper.new
    helper.run(ARGV, options)
  else
    raise "Language not supported."
  end
# rescue SystemExit, Interrupt => ex
  # puts "Caught #{ex}"
end

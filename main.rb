require_relative 'bundle/bundler/setup'
require 'open3'
require 'json'
require 'optparse'
require 'ostruct'
require 'docker'
require 'logger'
require_relative 'lib/docker_jockey'

options = OpenStruct.new
options.env_vars = []
options.ports = []
x = OptionParser.new do |opt|
  opt.banner = "Usage: dj LANG COMMAND [options]"
  opt.on('-e', '--env ENVVAR', 'An environment variable to pass into container.') { |o|
    options.env_vars << o
  }
  opt.on('-p', '--port PORT', 'Port mapping. Same usage as docker run -p.') { |o|
    options.ports << o
  }
  opt.on('-l', '--last_name LASTNAME', 'The last name') { |o| options.last_name = o }

  # No argument, shows at tail.  This will print an options summary.
  # Try it and see!
  opt.on_tail("-h", "--help", "Show this message") do
    puts opt
    exit
  end

  # Another typical switch to print the version.
  opt.on_tail("--version", "Show version") do
    puts IO.read('version.txt')
    exit
  end
end
x.order!

module DockerJockey
  @@docker_host = nil
  @@volumes = nil
  @@logger = nil

  def self.docker_host=(x)
    @@docker_host = x
  end

  def self.docker_host
    @@docker_host
  end

  def self.volumes=(x)
    @@volumes = x
  end

  def self.volumes
    @@volumes
  end
  def self.logger
    @@logger
  end
  def self.logger=(x)
    @@logger = x
  end

end
DockerJockey.logger = Logger.new(STDOUT)
DockerJockey.logger.level = ENV['LOG_LEVEL'] ?  Logger.const_get(ENV['LOG_LEVEL'].upcase) : Logger::INFO

@volumes = "-v \"#{Dir.pwd}\":/app"
begin
  # puts "inspect: #{`docker inspect $HOSTNAME`}"
  di = JSON.parse("#{`docker inspect $HOSTNAME`}")
  # p di
  @volumes = "--volumes-from #{di[0]['Name']}"
  DockerJockey.docker_host = di[0]
rescue => ex
  p ex
  puts "couldn't inspect"
end

if ARGV.length < 1
  DockerJockey.logger.fatal "No command provided."
  exit
end

# DockerJockey.logger.debug "Options: #{options.inspect}"

DockerJockey.volumes = @volumes

DockerJockey.logger.debug ARGV

begin
  lang = ARGV.shift
  case lang
  when 'git'
    helper = DockerJockey::GitHelper.new
    helper.run(ARGV, options)
  when 'go'
    helper = DockerJockey::GoHelper.new
    helper.run(ARGV, options)
  when 'ruby'
    helper = DockerJockey::RubyHelper.new
    helper.run(ARGV, options)
  when 'node'
    helper = DockerJockey::NodeHelper.new
    helper.run(ARGV, options)
  when 'python'
    helper = DockerJockey::PythonHelper.new
    helper.run(ARGV, options)
  when 'php'
    helper = DockerJockey::PhpHelper.new
    helper.run(ARGV, options)
  else
    puts "ERROR: Language not supported: #{lang}"
  end
# rescue SystemExit, Interrupt => ex
  # puts "Caught #{ex}"
end

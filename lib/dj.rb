# require_relative '../bundle/bundler/setup'
require 'open3'
require 'json'
require 'optparse'
require 'ostruct'
require 'docker'
require 'logger'

require_relative 'version'
require_relative 'executor'
require_relative 'image_helper'

require_relative 'langs/ruby_helper'
require_relative 'langs/node_helper'
require_relative 'langs/python_helper'
require_relative 'langs/php_helper'
require_relative 'langs/go_helper'

require_relative 'utils/git_helper'

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

  def self.run(args, options)
    begin
      lang = args.shift
      case lang
      when 'git'
        helper = DockerJockey::GitHelper.new
        helper.run(args, options)
      when 'go'
        helper = DockerJockey::GoHelper.new
        helper.run(args, options)
      when 'ruby'
        helper = DockerJockey::RubyHelper.new
        helper.run(args, options)
      when 'node'
        helper = DockerJockey::NodeHelper.new
        helper.run(args, options)
      when 'python'
        helper = DockerJockey::PythonHelper.new
        helper.run(args, options)
      when 'php'
        helper = DockerJockey::PhpHelper.new
        helper.run(args, options)
      else
        puts "ERROR: Language not supported: #{lang}"
      end
    # rescue SystemExit, Interrupt => ex
      # puts "Caught #{ex}"
    end
  end

end
DockerJockey.logger = Logger.new(STDOUT)
DockerJockey.logger.level = ENV['LOG_LEVEL'] ?  Logger.const_get(ENV['LOG_LEVEL'].upcase) : Logger::INFO

DockerJockey.logger.debug ARGV

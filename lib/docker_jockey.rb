require_relative 'executor'
require_relative 'image_helper'

require_relative 'langs/ruby_helper'
require_relative 'langs/node_helper'
require_relative 'langs/python_helper'
require_relative 'langs/php_helper'
require_relative 'langs/go_helper'

require_relative 'utils/git_helper'

require_relative 'deploy/digital_ocean'

module DockerJockey
  attr_accessor :config
  class Main
    def load_configs
      @config = {}
      begin
        fname = '/app/dj.secrets.json'
        if File.exist?(fname)
          file = File.read(fname)
          c = JSON.parse(file)
          @config = @config.merge(c)
        end
      rescue => ex
        puts "Error loading config file: #{ex.message}"
        raise ex
      end
    end
    def deploy(args, options)
      deployer = DigitalOcean.new(@config)
      deployer.deploy(args[0])
    end
  end
end

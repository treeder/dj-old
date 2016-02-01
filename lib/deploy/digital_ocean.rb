# TODO: I think this require takes a long time....
require 'droplet_kit'
require 'net/ssh'

module DockerJockey
  class DigitalOcean
    def initialize(config)
      @config = config
      if !@config['digital_ocean']
        raise "Invalid config, requires Digital Ocean access token."
      end
      @client = DropletKit::Client.new(access_token: @config['digital_ocean']['access_token'])
    end

    def deploy(image_name)
      # Can get image list with dj deploy list_images
      if image_name == 'list_images'
        list_images
        return
      end
      do_image_id = '14486461' # Ubuntu with Docker
      droplet = DropletKit::Droplet.new(name: image_name, region: 'nyc2', image: do_image_id, size: '512mb')
      created = client.droplets.create(droplet)
      p created

      Net::SSH.start('host', 'user', :password => "password") do |ssh|
        # capture all stderr and stdout output from a remote process
        output = ssh.exec!("hostname")
      end
    end

    def list_images
      images = @client.images.all
      images.each do |i|
        # puts "#{i.name} - #{i.id}"
        p i
      end
    end
  end
end

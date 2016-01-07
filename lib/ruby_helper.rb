
module Devo
  class RubyHelper

    attr_accessor :options

    def run(args=[], options)
      puts "rubyhelper"
      p args
      p options
      @options = options
      if args.length < 1
        raise "devo ruby: invalid args."
      end
      case args[0]
      when 'bundle', 'vendor'
        cmd = "install --standalone --clean"
        if args[1] == "update"
          cmd = "update"
        end
        Devo.docker_exec("iron/ruby:dev", "bundle config --local build.nokogiri --use-system-libraries && bundle #{cmd}", options)
        Devo.exec("chmod -R a+rw bundle")
        Devo.exec("chmod -R a+rw .bundle")
      when 'run'
        Devo.docker_exec("iron/ruby", "ruby #{args[1]}", options)
      when 'image'
        Devo::ImageHelper.build1('iron/ruby', 'ruby', args[1..args.length])
      when 'version'
        Devo.docker_exec("iron/ruby", "ruby -v", options)
      else
        raise "Invalid ruby command: #{args[0]}"
      end

    end
  end
end

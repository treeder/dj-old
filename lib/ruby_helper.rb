
module Devo
  class RubyHelper
    def image(args=[])
      if args.length < 2
        raise "devo: image command requires image name and ruby script to run."
      end
      ImageHelper.build1('iron/ruby', 'ruby', args)
    end
  end
end

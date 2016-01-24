
module Devo
  class GoHelper

    attr_accessor :options

    def run(args=[], options)
      @options = options
      if args.length < 1
        raise "devo go: invalid args: #{args.inspect}"
      end
      case args[0]
      when 'get', 'vendor'
script = script_base() + '
pwd
cat api.go
go get
cp -r $p/vendor $wd
chmod -R a+rw $wd/vendor
' + script_cleanup()
        # ["-w","/go/src/x/y/z","-e","GOPATH=/go/src/x/y/z/vendor:/go"]
        Devo.docker_exec_script("iron/go:dev", script, options)
      when 'build'
        # todo: use extra params provided by user, eg: #{args.join(' '). But need to parse -o to find output file name to copy
        build()
      when 'fmt'
        Devo.docker_exec("iron/go:dev", "go fmt", options)
      when 'static'
        static()
      when 'run'
        build()
        Devo.docker_exec("iron/go", "./app", options)
      when 'image'
        Devo::ImageHelper.build1('iron/go', './app', args[1..args.length])
      when 'version'
        Devo.docker_exec("iron/go:dev", "go version", options)
      else
        raise "Invalid Go command: #{args[0]}"
      end
    end
    def script_base
      script_base = '
set -e
#echo $PWD
wd=$PWD
defSrcPath="x/y/z"
if [ -z "$SRCPATH" ]; then
  SRCPATH=$defSrcPath
fi
#echo "srcpath $SRCPATH ---"
p=/go/src/$SRCPATH
mkdir -p $p
ls -al
if [ "$(ls -A $wd)" ]
then
  # only if files exist, errors otherwise
  cp -r * $p
fi
cd $p
export GOPATH=$p/vendor:/go
'
      script_base
    end
    def script_cleanup
      script_cleanup = '
rm -rf /go
'
      script_cleanup
    end

    def build()
      script = script_base() + "
      go build -o app
      cp app $wd
      chmod a+rwx $wd/app
      " + script_cleanup()
      Devo.docker_exec_script("iron/go:dev", script, options)
    end

    def static()
      script = script_base() + "
      CGO_ENABLED=0 go build -a --installsuffix cgo --ldflags=\"-s\" -o static
      cp static $wd
      chmod a+rwx $wd/static
      " + script_cleanup()
      Devo.docker_exec_script("iron/go:dev", script, options)
    end
  end
end

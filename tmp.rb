require_relative 'bundle/bundler/setup'
require 'docker'

image = 'iron/ruby'
mounts = []
mounts << {
           'Source' => Dir.pwd,
           'Destination': "/app",
           "Mode": "rw",
         }
coptions = {
  'Image' => image,
  # 'Cmd' => args,
  'Cmd' => ['sh', '-c', 'pwd && ls -al'],
  "AttachStdout": true,
  "AttachStderr": true,
  # 'Mounts' => mounts,
  # "Env": [
          #  "FOO=bar",
          #  "BAZ=quux"
  #  ],
  'WorkingDir' => '/app',
  # 'Volumes' => {
      # "/app": {}
    # },
  "HostConfig" => {
    # 'VolumesFrom' => [DockerJockey.docker_host['Name']]
    "Binds": ["#{Dir.pwd}:/app"]
  },
}
puts "container options:"
p coptions
container = Docker::Container.create(coptions)
p container.json
puts "tapping"
container.tap(&:start).streaming_logs(follow:true, stdout: true, stderr: true) { |stream, chunk| puts "#{stream}: #{chunk}" }
# container.tap(&:start).attach(:stream => true, :stdin => nil, :stdout => true, :stderr => true) { |stream, chunk| puts "#{stream}: #{chunk}" }
container.delete(:force => true)

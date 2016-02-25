require_relative "lib/version"

Gem::Specification.new do |s|
  s.name        = 'dj2' # temporary
  s.version     = DockerJockey::VERSION
  s.date        = '2010-04-28'
  s.summary     = "Docker Jockey"
  s.description = "One dev tool to rule them all."
  s.authors     = ["Travis Reeder"]
  s.email       = 'treeder@gmail.com'
  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'
  s.executables << 'dj'
  s.homepage    =
    'https://github.com/treeder/dj'
  s.license       = 'MIT'

  s.add_runtime_dependency 'docker-api'
  s.add_runtime_dependency 'droplet_kit'

end

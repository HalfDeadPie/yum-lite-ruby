require File.expand_path('lib/yum/version', __dir__)

Gem::Specification.new do |s|
  s.name        = 'yum'
  s.version     = Yum::VERSION
  s.homepage    = 'https://github.com/HalfDeadPie/yum-lite-ruby'
  s.license     = 'MIT'
  s.author      = 'Simon Štefunko'
  s.email       = 's.stefunko@gmail.com'

  s.summary     = 'Improve your cooking skills'

  s.files       = Dir['bin/*', 'lib/**/*', '*.gemspec', 'LICENSE*', 'README*']
  s.executables = Dir['bin/*'].map { |f| File.basename(f) }
  s.has_rdoc    = 'yard'

  s.required_ruby_version = '>= 2.2'

  #s.add_runtime_dependency 'thor', '~> 0.20.0'

  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rspec', '~> 3.6'
  s.add_development_dependency 'yard', '~> 0.9'
end
Gem::Specification.new do |s|
  s.name        = 'manatoo'
  s.version     = '0.0.1'
  s.required_ruby_version = ">= 2.0.0"
  s.date        = '2018-02-16'
  s.summary     = "Manatoo api ruby bindings"
  s.description = "Manatoo is an api first todo list that allows your products to tell you what to do"
  s.authors     = ["Derek Zhou"]
  s.email       = 'derek@manatoo.io'
  s.files       = ['lib/manatoo.rb', 'lib/manatoo/task.rb']
  s.homepage    =
    'http://rubygems.org/gems/manatoo'
  s.license       = 'MIT'
  s.add_dependency("faraday", "~> 0.10")
  s.add_dependency("plissken", "~> 1.0")
  s.add_development_dependency("rspec")
end

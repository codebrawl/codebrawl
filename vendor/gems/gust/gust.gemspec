# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = "gust"
  s.version     = '0.1.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "gust"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'pygments.rb', ['~> 0.1.2']
  s.add_dependency 'kramdown', ['~> 0.13.3']
  s.add_dependency 'RedCloth', ['~> 4.2.7']
end

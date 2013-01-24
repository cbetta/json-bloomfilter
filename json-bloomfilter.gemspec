# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "json-bloomfilter/version"

Gem::Specification.new do |s|
  s.name        = "json-bloomfilter"
  s.version     = JsonBloomfilter::VERSION
  s.authors     = ["Cristiano Betta"]
  s.email       = ["cbetta@gmail.com"]
  s.homepage    = "http://github.com/cbetta/json-bloomfilter"
  s.summary     = "A bloomfilter implementation in both Ruby and Javascript."
  s.description = "A bloomfilter implementation in both Ruby and Javascript that can be serialised to and loaded from JSON. Very useful when needing to train a bloom filter in one language and using it in the other."
  s.license     = 'MIT'
  s.required_ruby_version = '>= 1.9.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'json'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yui-compressor'
  s.add_development_dependency 'therubyracer'
  s.add_development_dependency 'coffee-script'
  s.add_development_dependency 'fssm'
  s.add_development_dependency 'rb-fsevent'
  s.add_development_dependency 'jasmine'
end

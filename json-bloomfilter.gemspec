# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "json/bloomfilter/version"

Gem::Specification.new do |s|
  s.name        = "json-bloomfilter"
  s.version     = JsonBloomfilter::VERSION
  s.authors     = ["Cristiano Betta"]
  s.email       = ["cbetta@gmail.com"]
  s.homepage    = "http://github.com/cbetta/json-bloomfilter"
  s.summary     = "A bloomfilter implementation in both Ruby and Javascript."
  s.description = "A bloomfilter implementation in both Ruby and Javascript that can be serialised to and loaded from JSON. Very useful when needing to train a bloom filter in one language and using it in the other."

  s.rubyforge_project = "json-bloomfilter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "millionaire/version"

Gem::Specification.new do |s|
  s.name        = "millionaire"
  s.version     = Millionaire::VERSION
  s.authors     = ["HIDEKUNI Kajita"]
  s.email       = ["hide.nba@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Simple use the CSV}
  s.description = %q{You can do the CSV file by specifying the column to include a millionaire.}

  s.rubyforge_project = "millionaire"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "tapp"

  s.add_dependency "activemodel"
  s.add_dependency "activesupport"

  s.required_ruby_version = '>= 1.9.2'
end

# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bandicoot/version"

Gem::Specification.new do |s|
  s.name        = "bandicoot"
  s.version     = Bandicoot::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Hughes"]
  s.email       = ["ben@nabewise.com"]
  s.homepage    = ""
  s.summary     = %q{Easy resume/save point lib}
  s.description = %q{Doesn't it suck when a long running task crashes?  Wouldn't it be great to resume from more or less where you left off.}

  s.rubyforge_project = "bandicoot"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "msgpack"

  s.add_development_dependency "mocha"
  s.add_development_dependency "fakefs"
end

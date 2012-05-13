# -*- encoding: utf-8 -*-
require File.expand_path('../lib/autoexec_bat/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gudleik Rasch"]
  gem.email         = ["gudleik@gmail.com"]
  gem.description   = %q{Autoexecution of javascript based on data attribute}
  gem.summary       = %q{Autoexecution of javascript based on data attribute}
  gem.homepage      = "https://github.com/Skalar/autoexec_bat"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "autoexec_bat"
  gem.require_paths = ["lib"]
  gem.version       = AutoexecBat::VERSION
end

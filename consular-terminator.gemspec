$:.push File.expand_path("../lib", __FILE__)
require 'consular/terminator/version'

Gem::Specification.new do |s|
  s.name = 'consular-terminator'
  s.version = Consular::Terminator::VERSION
  s.authors = ['Ilkka Laukkanen']
  s.email = [%q{ilkka.s.laukkanen@gmail.com}]
  s.homepage = %q{http://github.com/ilkka/consular-terminator}
  s.summary = %q{Terminator support for Consular}
  s.licenses = ["GPLv3"]
  s.description = 
    %q{Add support for automating the Terminator terminal with Consular.}

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/* spec/* features/*`.split("\n")

  s.extra_rdoc_files = [
    'LICENSE.txt',
    'README.rdoc'
  ]
  s.require_paths = ["lib"]

  s.add_runtime_dependency('consular')

  s.add_development_dependency('rake')
  s.add_development_dependency('rspec')
  s.add_development_dependency('yard')
  s.add_development_dependency('cucumber')
  s.add_development_dependency('spork')
  s.add_development_dependency('watchr')
end

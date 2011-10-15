# Terminator support for Consular
# Copyright (C) 2011 Ilkka Laukkanen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
  s.add_development_dependency('bundler')
  s.add_development_dependency('mocha')
end

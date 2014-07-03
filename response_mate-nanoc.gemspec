# coding: utf-8
require File.expand_path('../lib/response_mate/nanoc/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'response_mate-nanoc'
  s.version       = ResponseMate::Nanoc::VERSION
  s.date          = '2012-12-20'
  s.summary       = %{ResponseMate for nanoc}
  s.description   = %{Helpers and formatters for displaying ResponseMate output in nanoc}
  s.authors       = ['Dimitris Karakasilis', 'Dimitris Zorbas']
  s.email         = 'jimmykarily@gmail.com'
  s.files         = `git ls-files`.split($\)
  s.homepage      = ''
  s.license       = 'MIT'

  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-nav'
  s.add_development_dependency 'rspec', '~> 2.14'

  s.add_dependency 'response_mate', '~> 0.1.6'
end

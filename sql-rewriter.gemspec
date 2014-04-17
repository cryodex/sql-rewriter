$:.push File.expand_path('../lib', __FILE__)
require 'sql-rewriter/version'

Gem::Specification.new do |s|
  
  s.name        = 'sql-rewriter'
  s.version     = SQLRewriter::VERSION
  s.authors     = ['Louis Mullie']
  s.email       = ['louis.mullie@gmail.com']
  s.homepage    = 'https://github.com/louismullie/sql-parser'
  s.summary     = %q{ Ruby library for SQL injection and re-writing in ActiveRecord }
  s.description = %q{ Ruby library for SQL injection and re-writing in ActiveRecord }

  s.files = Dir.glob('lib/**/*')
  
  s.add_runtime_dependency 'sql-parser'
  
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  
end
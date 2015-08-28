# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heydan/version'

Gem::Specification.new do |spec|
  spec.name          = "heydan"
  spec.version       = HeyDan::VERSION
  spec.authors       = ["Dan Melton"]
  spec.email         = ["melton.dan@gmail.com"]

  spec.summary       = %q{HeyDan munges data for jurisdictions}
  spec.description   = %q{Use HeyDan to download, munge and manage data for jurisdictions}
  spec.homepage      = "http://github.com/danmelton/heydan"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['heydan']
  spec.require_paths = ["lib"]

  #depedencies
  spec.add_dependency "thor", "~> 0.19"
  spec.add_dependency "rubyzip", "~>1.1"
  spec.add_dependency "git", "~>1.2"
  spec.add_dependency "pry", "~> 0.10"
  spec.add_dependency "ruby-progressbar","~>1.7"
  spec.add_dependency "elasticsearch","~>1.0"
  spec.add_dependency "sinatra","~>1.4"
  spec.add_dependency "sinatra-cross_origin","~>0.3"
  spec.add_dependency "fog-aws", "~>0.7.5"
  spec.add_dependency "georuby", "~>2.5"
  spec.add_dependency "spreadsheet", "~>1.0"
  spec.add_dependency "dbf", "~> 2.0"
  spec.add_dependency "rubyXL", "~> 3.3"


  #development/test depedencies
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

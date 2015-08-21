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
  spec.homepage      = "httpa://github.com/danmelton/heydan"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ['heydan']
  spec.require_paths = ["lib"]

  #depedencies
  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "rubyzip"

  #development/test depedencies
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end
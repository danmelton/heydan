require 'rubygems'
require 'bundler'
require 'yaml'
require 'json'
require 'csv'
Bundler.setup(:default)

yml = YAML.load(File.read(File.join(Dir.pwd, 'settings.yml')))
settings  = yml[ENV['heydan_env'] || 'dev']
settings.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}

SETTINGS = settings

class HeyDan
  attr_accessor :settings
  
  def initialize(opts={})
    @settings = SETTINGS
  end

  def self.settings
    yml = YAML.load(File.read(File.join(Dir.pwd, 'settings.yml')))
    @settings  = yml[ENV['heydan_env'] || 'dev']
    @settings.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}
    @settings
  end

end

require File.join(Dir.pwd, 'lib', 'helpers')
require File.join(Dir.pwd, 'lib', 'jurisdiction_file')
require File.join(Dir.pwd, 'lib', 'dataset')
require File.join(Dir.pwd, 'lib', 'script')
require File.join(Dir.pwd, 'lib', 'identifier')
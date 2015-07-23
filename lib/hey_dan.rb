require 'rubygems'
require 'bundler'
require 'yaml'
Bundler.setup(:default)

class HeyDan
  attr_accessor :settings
  
  def initialize(opts={})
    if opts[:settings]
      @settings = opts[:settings]
    else
      raise "No settings.yml file found" if !File.exists?(File.join(Dir.pwd, 'settings.yml'))
      yml = YAML.load(File.read(File.join(Dir.pwd, 'settings.yml')))
      yml.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}
      @settings  = yml
    end
  end

end

require File.join(Dir.pwd, 'lib', 'dataset')
require 'spec_helper'
require 'fileutils'

describe HeyDan::Script do
  before do
    ENV['heydan_env'] = 'test'
    yml = YAML.load(File.read(File.join(Dir.pwd, 'settings.yml')))
    @settings  = yml[ENV['heydan_env'] || 'dev']
    @settings.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample_identifier.rb'), File.join(@settings[:scripts_folder], "sample_identifier.rb"))
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample_identifier.json'), File.join(@settings[:identifiers_folder], "sample_identifier.json"))
    @identifier = HeyDan::Identifier.new({name: 'sample_identifier'})    
  end

  it 'valid_json?' do
    expect(@identifier.valid_json?).to eq true
  end

  after do
    FileUtils.rm(File.join(@settings[:scripts_folder], "sample_identifier.rb"))
    FileUtils.rm(File.join(@settings[:identifiers_folder], "sample_identifier.json"))
  end
end
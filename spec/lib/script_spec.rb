require 'spec_helper'
require 'fileutils'

describe HeyDan::Script do
  before do
    ENV['heydan_env'] = 'test'
    yml = YAML.load(File.read(File.join(Dir.pwd, 'settings.yml')))
    @settings  = yml[ENV['heydan_env'] || 'dev']
    @settings.default_proc = proc{|h, k| h.key?(k.to_s) ? h[k.to_s] : nil}
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample_dataset.rb'), File.join(@settings[:scripts_folder], "sample_dataset.rb"))
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample_dataset.json'), File.join(@settings[:datasets_folder], "sample_dataset.json"))
    @script = HeyDan::Script.new({name: 'sample_dataset'})    
  end

  
  it 'process calls methods' do
    expect(@script).to receive(:get_data).and_return(true)
    expect(@script).to receive(:transform_data).and_return(true)
    expect(@script).to receive(:save_data).and_return(true)
    expect(@script).to receive(:validate_process).and_return(true)
    @script.process
  end

  it 'validate_process' do
    expect{@script.validate_process}.to raise_error('File did not save')
    File.open(File.join(@script.settings[:downloads_folder], "#{@script.name}.csv"), 'w') do |f|
      f << ""
    end
    FileUtils.rm(File.join(@script.settings[:downloads_folder], "#{@script.name}.csv"))
  end

  it 'process' do
    expect(File.exists?(File.join(@script.settings[:downloads_folder], "#{@script.name}.csv"))).to eq false
    HeyDan::Script.process(['sample_dataset'])
    expect((File.exists?File.join(@script.settings[:downloads_folder], "#{@script.name}.csv"))).to eq true
    FileUtils.rm(File.join(@script.settings[:downloads_folder], "#{@script.name}.csv"))
  end

  after do
    FileUtils.rm(File.join(@settings[:scripts_folder], "sample_dataset.rb"))
    FileUtils.rm(File.join(@settings[:datasets_folder], "sample_dataset.json"))
  end
end
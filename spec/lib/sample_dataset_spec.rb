require 'spec_helper'
require 'fileutils'

describe 'SampleDataSet' do
  before do
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample.rb'), File.join(HEYDANSETTINGS[:scripts_folder], "sample.rb"))
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'sample.json'), File.join(HEYDANSETTINGS[:datasets_folder], "sample.json"))
  end

  it 'processes a file' do
    
  end

  after do
    FileUtils.rm(File.join(HEYDANSETTINGS[:scripts_folder], "sample.rb"))
    FileUtils.rm(File.join(HEYDANSETTINGS[:datasets_folder], "sample.json"))
  end

end
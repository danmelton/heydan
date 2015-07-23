require 'spec_helper'

describe HeyDan::Dataset do
  before do
    @dataset = HeyDan::Dataset.new({name: 'decennial_census_total_population'})
  end

  it 'sets the name' do
    expect(@dataset.name).to eq "decennial_census_total_population"
  end

  it 'create_ruby_file' do
    @dataset.create_ruby_file
    expect(File.exists?(File.join(@dataset.settings[:scripts_folder], "#{@dataset.name}.rb"))).to eq true
  end

  it 'create_json_file' do
    @dataset.create_json_file
    expect(File.exists?(File.join(@dataset.settings[:datasets_folder], "#{@dataset.name}.json"))).to eq true
  end

  it 'valid_name?' do
    expect(@dataset.valid_name?).to eq true
    @dataset.name = 'love love'
    expect(@dataset.valid_name?).to eq false
  end

  it 'file_exist?' do
    require 'fileutils'
    FileUtils.rm(File.join(@dataset.settings[:scripts_folder], "#{@dataset.name}.rb"))
    FileUtils.rm(File.join(@dataset.settings[:datasets_folder], "#{@dataset.name}.json"))
    expect(@dataset.file_exist?).to eq false
    FileUtils.touch(File.join(@dataset.settings[:scripts_folder], "#{@dataset.name}.rb"))
    expect(@dataset.file_exist?).to eq true
    FileUtils.rm(File.join(@dataset.settings[:scripts_folder], "#{@dataset.name}.rb"))
    FileUtils.touch(File.join(@dataset.settings[:datasets_folder], "#{@dataset.name}.json"))
    expect(@dataset.file_exist?).to eq true
    FileUtils.rm(File.join(@dataset.settings[:datasets_folder], "#{@dataset.name}.json"))
  end

  it 'valid_json?' do
    @dataset.create_json_file
    expect(@dataset.valid_json?).to eq true
    File.open(File.join(@dataset.settings[:datasets_folder], "#{@dataset.name}.json"), 'w') do |f|
      f << "nope"
    end
    expect(@dataset.valid_json?).to eq false
  end


end
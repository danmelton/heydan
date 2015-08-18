require 'spec_helper'

describe HeyDan::Source do
  before do
    @source = HeyDan::Source.new({name: 'decennial_census_total_population'})
    FileUtils.cp(File.join(Dir.pwd, 'spec', 'fixtures', 'template.json.erb'), File.join(@source.settings[:sources_folder], "template.json.erb"))
  end

  it 'sets the name' do
    expect(@source.name).to eq "decennial_census_total_population"
  end

  it 'create_ruby_file' do
    @source.create_ruby_file
    expect(File.exists?(File.join(@source.settings[:scripts_folder], "#{@source.name}.rb"))).to eq true
  end

  it 'create_json_file' do
    @source.create_json_file
    expect(File.exists?(File.join(@source.settings[:sources_folder], "#{@source.name}.json"))).to eq true
  end

  it 'valid_name?' do
    expect(@source.valid_name?).to eq true
    @source.name = 'love love'
    expect(@source.valid_name?).to eq false
  end

  it 'file_exist?' do
    require 'fileutils'
    FileUtils.rm(File.join(@source.settings[:scripts_folder], "#{@source.name}.rb"))
    FileUtils.rm(File.join(@source.settings[:sources_folder], "#{@source.name}.json"))
    expect(@source.file_exist?).to eq false
    FileUtils.touch(File.join(@source.settings[:scripts_folder], "#{@source.name}.rb"))
    expect(@source.file_exist?).to eq true
    FileUtils.rm(File.join(@source.settings[:scripts_folder], "#{@source.name}.rb"))
    FileUtils.touch(File.join(@source.settings[:sources_folder], "#{@source.name}.json"))
    expect(@source.file_exist?).to eq true
    FileUtils.rm(File.join(@source.settings[:sources_folder], "#{@source.name}.json"))
  end

  it 'valid_json?' do
    @source.create_json_file
    expect(@source.valid_json?).to eq true
    File.open(File.join(@source.settings[:sources_folder], "#{@source.name}.json"), 'w') do |f|
      f << "nope"
    end
    expect(@source.valid_json?).to eq false
  end

after do
  FileUtils.rm(File.join(@source.settings[:sources_folder], "template.json.erb"))
end

end
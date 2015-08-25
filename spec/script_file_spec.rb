require 'spec_helper'

describe HeyDan::ScriptFile do
  before do
    @script_file = HeyDan::ScriptFile.new('heydan_source', 'census', 'population')
  end

  it "has the proper attributes" do
    expect(@script_file.folder).to eq 'heydan_source'
    expect(@script_file.source).to eq 'census'
    expect(@script_file.variable).to eq 'population'
    expect(@script_file.name).to eq 'heydan_source_census_population'
    expect(@script_file.class_name).to eq 'HeydanSourceCensusPopulation'
    expect(@script_file.script_folder_path).to eq 'spec/tmp/sources/heydan_source/scripts'
    expect(@script_file.script_file_path).to eq 'spec/tmp/sources/heydan_source/scripts/heydan_source_census_population.rb'
  end

  it 'create_script_folder' do
    expect(Dir.exist?('spec/tmp/sources/heydan_source/scripts')).to be false
    @script_file.create_script_folder
    expect(Dir.exist?('spec/tmp/sources/heydan_source/scripts')).to be true
  end

  it 'save' do
    expect(File.exist?('spec/tmp/sources/heydan_source/scripts/heydan_source_census_population.rb')).to be false
    @script_file.save
    expect(File.exist?('spec/tmp/sources/heydan_source/scripts/heydan_source_census_population.rb')).to be true
  end

  it 'template' do
    expect(@script_file.template.include?("class HeydanSourceCensusPopulation < HeyDan::Script\n")).to be true
    expect(@script_file.template.include?("def type\n")).to be true
    expect(@script_file.template.include?("def build\n")).to be true
    expect(@script_file.template.include?("def version\n")).to be true
  end

  it 'eval_class' do
    @script_file.save
    expect(@script_file.eval_class).to eq HeydanSourceCensusPopulation
  end
end
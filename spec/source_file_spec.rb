require 'spec_helper'

describe HeyDan::SourceFile do
  before do
    @source_file = HeyDan::SourceFile.new('heydan_sources', 'census')
  end

  it 'new' do
    expect(@source_file.folder).to eq 'heydan_sources'
    expect(@source_file.name).to eq 'census'
    expect(@source_file.folder_path).to eq "spec/tmp/sources/heydan_sources"
    expect(@source_file.file_path).to eq "spec/tmp/sources/heydan_sources/census"
  end

  it 'exist?' do
    expect(@source_file.exist?).to eq false
  end

  it 'initial_json' do
    expect(@source_file.initial_json.keys).to eq ["name", "short_description", "long_description", "notes", "depends", "sourceUrl", "variables"]
  end

  it 'variable_json(variable_name)' do
    expect(@source_file.variable_json('census').keys).to eq ["name", "short_description", "long_description", "notes", "identifier", "dates", "tags", "sourceUrl", "jurisdiction_types", "coverage"]
  end

  it 'add_variable(variable_name)' do
    expect(@source_file.json['variables']).to eq ({})
    @source_file.add_variable('population')
    @source_file.add_variable('housing_units')
    expect(@source_file.json['variables'].keys).to eq ["population", "housing_units"]
  end

  it 'create_script_file(variable_name)' do
    expect(HeyDan::ScriptFile).to receive(:new).with("heydan_sources", "census", "population").and_return(double('HeyDan::ScriptFile', {save: true}))
    @source_file.create_script_file('population')
  end

  it 'create_folder' do
    expect(Dir.exist?(@source_file.folder_path)).to eq false
    @source_file.create_folder
    expect(Dir.exist?(@source_file.folder_path)).to eq true
  end

  it 'save' do
    expect(@source_file.exist?).to eq false
    @source_file.save
    expect(@source_file.exist?).to eq true
  end
  
  context 'get_json' do

    it 'creates new' do
      @source_file = HeyDan::SourceFile.new('heydan_sources', 'census')
      expect(@source_file.exist?).to eq false
      expect(@source_file.get_json.keys).to eq ["name", "short_description", "long_description", "notes", "depends", "sourceUrl", "variables"]
    end

    it 'loads from file' do
      @source_file = HeyDan::SourceFile.new('heydan_sources', 'census')
      @source_file.add_variable('population')
      expect(@source_file).to receive(:create_script_file).with('population').and_return true
      @source_file.save
      expect(@source_file.exist?).to eq true
      @source_file1 = HeyDan::SourceFile.new('heydan_sources', 'census')
      expect(@source_file1.exist?).to eq true
      expect(@source_file1.variable('population')).to_not eq nil
    end

  end

end

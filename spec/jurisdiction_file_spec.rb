require 'spec_helper'
require 'fileutils'

describe HeyDan::JurisdictionFile do
  before do
    @jf = HeyDan::JurisdictionFile.new({name: 'country:us'})    
  end

  it 'type' do
    expect(HeyDan::JurisdictionFile.new({name: 'country:us'}).type).to eq 'country'
    expect(HeyDan::JurisdictionFile.new({name: 'country:us/state:ca'}).type).to eq 'state'
  end

  it 'file_name' do
    expect(@jf.file_name).to eq 'country:us.json'
  end

  it 'convert_file_name' do
    jf = HeyDan::JurisdictionFile.new({name: 'country:us::state:ca.json'})
    expect(jf.name).to eq "country:us/state:ca"
    expect(jf.file_name).to eq "country:us::state:ca.json"
  end

  it 'folder_path' do
    
    expect(@jf.folder_path.include?('spec/tmp/jurisdictions')).to eq true
  end

  it 'file_path' do
    expect(@jf.file_path.include?('spec/tmp/jurisdictions/country:us.json')).to eq true
  end

  it 'type' do
    expect(@jf.type).to eq 'country'
  end

  it 'exists?' do
    expect(@jf.exists?).to eq false
    FileUtils.touch(@jf.file_path)
    expect(@jf.exists?).to eq true
  end

  it 'get_json' do
    expect(@jf.get_json).to eq ( {"id"=>"country:us", "entityType"=>"country", "identifiers"=>{}, "datasets"=>{}})
    expect(@jf.json).to eq ({"id"=>"country:us", "entityType"=>"country", "identifiers"=>{}, "datasets"=>{}})
  end

  it "add_property" do
    @jf.add_property('name', 'love')
    expect(@jf.json['name']).to eq 'love'
  end

  it "add_identifier" do
    @jf.add_identifier('open_civic_identifier', 'country:us')
    expect(@jf.json['identifiers']['open_civic_identifier']).to eq 'country:us'
  end

  it "add_dataset" do
    @jf.add_dataset('population', 'decennial_census_population', {years: [2010], data: [1]})
    expect(@jf.json['datasets']['population']['decennial_census_population']).to eq ({:years=>[2010], :data=>[1]})
  end

  it 'save' do
    @jf.add_property('name', 'love')
    expect(@jf.get_json).to eq ( {"id"=>"country:us", "entityType"=>"country", "identifiers"=>{}, "datasets"=>{}, "name"=>"love"})
  end


end
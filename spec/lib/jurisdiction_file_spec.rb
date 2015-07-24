require 'spec_helper'
require 'fileutils'

describe HeyDan::JurisdictionFile do
  before do
    @jf = HeyDan::JurisdictionFile.new({name: 'ocd-division/country:us'})    
    FileUtils.rm(@jf.file_path) if File.exists?(@jf.file_path)
  end

  it 'type' do
    expect(HeyDan::JurisdictionFile.new({name: 'ocd-division/country:us'}).type).to eq 'country'
    expect(HeyDan::JurisdictionFile.new({name: 'ocd-division/country:us/state:ca'}).type).to eq 'state'
  end

  it 'file_name' do
    expect(@jf.file_name).to eq 'country:us.json'
  end

  it 'folder_path' do
    expect(@jf.folder_path.include?('spec/tmp/jurisdictions')).to eq true
  end

  it 'file_path' do
    expect(@jf.file_path.include?('spec/tmp/jurisdictions/country:us.json')).to eq true
  end

  it 'exists?' do
    expect(@jf.exists?).to eq false
    FileUtils.touch(@jf.file_path)
    expect(@jf.exists?).to eq true
  end

  it 'get_json' do
    expect(@jf.get_json).to eq ({"id"=>"ocd-division/country:us", "identifiers"=>{}, "datasets"=>{}})
    expect(@jf.json).to eq ({"id"=>"ocd-division/country:us", "identifiers"=>{}, "datasets"=>{}})
  end

  it "add_property" do
    @jf.add_property('name', 'love')
    expect(@jf.json['name']).to eq 'love'
  end

  it "add_identifier" do
    @jf.add_identifier('open_civic_identifier', 'ocd-division/country:us')
    expect(@jf.json['identifiers']['open_civic_identifier']).to eq 'ocd-division/country:us'
  end

  it "add_dataset" do
    @jf.add_dataset('population', 'decennial_census_population', {years: [2010], data: [1]})
    expect(@jf.json['datasets']['population']['decennial_census_population']).to eq ({:years=>[2010], :data=>[1]})
  end

  it 'save' do
    @jf.add_property('name', 'love')
    expect(@jf.get_json).to eq ({"id"=>"ocd-division/country:us", "identifiers"=>{}, "datasets"=>{}, "name" => "love"})
  end


end
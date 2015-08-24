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
    expect(@jf.get_json).to eq ({"id"=>"country:us", "entityType"=>"country", "attributes"=>{}, "identifiers"=>{}, "datasets"=>[]})
    expect(@jf.json).to eq ({"id"=>"country:us", "entityType"=>"country", "attributes"=>{}, "identifiers"=>{}, "datasets"=>[]})
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
    @jf.add_dataset({years: [2010], data: [1]})
    expect(@jf.json['datasets']).to eq ([{:years=>[2010], :data=>[1]}])
  end

  it 'save' do
    @jf.add_property('name', 'love')
    expect(@jf.get_json).to eq ( {"id"=>"country:us", "entityType"=>"country", "attributes"=>{}, "identifiers"=>{}, "datasets"=>[], "name"=>"love"})
  end

  context 'match_type?' do

    it 'matches country:us' do
      @jf.get_json
      @jf.json['id'] = 'country:us'
      expect(@jf.match_type?('country:us')).to be true
      @jf.json['id'] = 'country:ca'
      expect(@jf.match_type?('country:us')).to be false
      @jf.json['id'] = 'country:ca'
      expect(@jf.match_type?('country:all')).to be true
    end

    it 'matches country:us/state:al' do
      @jf.get_json
      @jf.json['id'] = 'country:us/state:al'
      expect(@jf.match_type?('state:al')).to be true
      expect(@jf.match_type?('country:us/state:all')).to be true
      expect(@jf.match_type?('state:all')).to be true
      expect(@jf.match_type?('country:us/state:ca')).to be false
    end

    it 'matches country:us/state:al/school_district:oakland_unified' do
      @jf.get_json
      @jf.json['id'] = 'country:us/state:al/school_district:oakland_unified'
      expect(@jf.match_type?('state:al/school_district:all')).to be true
      expect(@jf.match_type?('school_district:all')).to be true
      expect(@jf.match_type?('state:all')).to be true
      expect(@jf.match_type?('country:us/state:ca')).to be false
    end

  end


end
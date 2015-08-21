require 'spec_helper'

describe HeyDan::Script do
  before do
    @script = HeyDan::Script.new({folder: 'heydan_sources', source: 'census', variable: 'population', fromsource: true, type: 'school_district'})
  end
  let(:dataset) {[['open_civic_id', 2015, 2014],['country:us', 1,2]]}
  let(:property) {[['open_civic_id', 'name'],['country:us', 'United States of America']]}
  let(:attribute) {[['open_civic_id', 'website'],['country:us', 'http://www.whitehouse.gov']]}
  let(:identifier) {[['open_civic_id', 'ansi_id'],['country:us/state:al', '01']]}
  
  it 'sets variables' do
    expect(@script.folder).to eq 'heydan_sources'
    expect(@script.source).to eq 'census'
    expect(@script.variable).to eq 'population'
    expect(@script.jurisdiction_type).to eq 'school_district'
    expect(@script.fromsource).to eq true
  end

  it 'dataset_file_name' do
    expect(@script.dataset_file_name).to eq 'heydan_sources_census_population.csv'
  end

  it 'dataset_file_path' do
    expect(@script.dataset_file_path).to eq 'spec/tmp/datasets/heydan_sources_census_population.csv'
  end

  it 'download' do
    expect(HeyDan::Helper).to receive(:get_data_from_url).with('https://heydan.s3-us-west-1.amazonaws.comheydan_sources_census_population.csv').and_return(dataset)
    @script.download
    expect(@script.data).to eq dataset
  end

  context 'process' do

    it 'fromsource is true' do
      expect(@script).to receive(:build).and_return(true)
      expect(@script).to receive(:validate_build).and_return(true)
      expect(HeyDan::Helper).to receive(:save_data).with(@script.dataset_file_name, dataset)
      expect(@script).to receive(:filter_jurisdiction_type).and_return(true)
      expect(@script).to receive(:update_jurisdiction_files).and_return(true)
      expect(@script).to receive(:validate_update).and_return(true)
      @script.data = dataset
      @script.process
    end

    it 'fromsource is false' do
      @script.fromsource = false
      expect(@script).not_to receive(:build)
      expect(@script).not_to receive(:validate_build)
      expect(HeyDan::Helper).not_to receive(:save_data)
      expect(@script).to receive(:download).and_return(dataset)
      expect(@script).to receive(:filter_jurisdiction_type).and_return(true)
      expect(@script).to receive(:update_jurisdiction_files).and_return(true)
      expect(@script).to receive(:validate_update).and_return(true)
      @script.process
    end


  end

end

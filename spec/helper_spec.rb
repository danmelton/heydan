require 'spec_helper'

describe HeyDan do
  before do
    HeyDan.folders = {:jurisdictions=>"spec/tmp/jurisdictions", 
        :sources=>"spec/tmp/sources", :downloads=>"spec/tmp/downloads", :datasets=>"spec/tmp/datasets"}
  end

  let(:downloads_folder) {File.join('spec', 'tmp', 'downloads')}
  let(:csv_example) {File.join('spec', 'fixtures', 'example.csv')}
  let(:csv_tab_example) {File.join('spec', 'fixtures', 'example_tab.csv')}
  let(:txt_example) {File.join('spec', 'fixtures', 'example.txt')}
  let(:zip_example) {File.join('spec', 'fixtures', 'example.zip')}

  it 'get_file_type_from_url(url)' do
    expect(HeyDan::Helper.get_file_type_from_url('http://love.com/lover.zip')).to eq 'zip'
    expect(HeyDan::Helper.get_file_type_from_url('http://love.com/lover.csv')).to eq 'csv'
    expect(HeyDan::Helper.get_file_type_from_url('http://love.com/lover.txt')).to eq 'txt'
    expect(HeyDan::Helper.get_file_type_from_url('http://love.com/lover')).to eq ''
  end

  it 'md5_name' do
    expect(HeyDan::Helper.md5_name("love")).to eq 'b5c0b187fe309af0f4d35982fd961d7e'
  end

  it 'download_file' do
    VCR.use_cassette('example.txt') do
      expect(File.exist?('spec/tmp/downloads/example.txt')).to eq false
      f = HeyDan::Helper.download_file('https://s3-us-west-1.amazonaws.com/heydan/spec/example.txt', File.join(HeyDan.folders[:downloads], 'example.txt'))
      expect(File.exist?('spec/tmp/downloads/example.txt')).to eq true
      expect(f).to eq "spec/tmp/downloads/example.txt"
    end
    VCR.use_cassette('example.csv') do
      expect(File.exist?('spec/tmp/downloads/example.csv')).to eq false
      f= HeyDan::Helper.download_file('https://s3-us-west-1.amazonaws.com/heydan/spec/example.csv', File.join(HeyDan.folders[:downloads], 'example.csv'))
      expect(File.exist?('spec/tmp/downloads/example.csv')).to eq true
      expect(f).to eq "spec/tmp/downloads/example.csv"
    end
    VCR.use_cassette('example.zip') do
      expect(File.exist?('spec/tmp/downloads/example.zip')).to eq false
      f = HeyDan::Helper.download_file('https://s3-us-west-1.amazonaws.com/heydan/spec/example.zip', File.join(HeyDan.folders[:downloads], 'example.zip'))
      expect(File.exist?('spec/tmp/downloads/example.zip')).to eq true
      expect(f).to eq "spec/tmp/downloads/example.zip"
    end    
  end

  context 'csv' do
    it 'is_csv?' do
      expect(HeyDan::Helper.is_csv?(csv_tab_example)).to be true
    end

    it 'get_csv_data' do
      expect(HeyDan::Helper.get_csv_data(csv_example)).to eq [["this is a csv", " with", " three columns"], ["1", " 2", " 3"], ["4", " 5", " 6"]]
    end

    it 'get_csv_data with tabs' do
      expect(HeyDan::Helper.get_csv_data(csv_tab_example)).to eq [["this is a tab csv", "with", "three columns"], ["1", "2", "3"], ["4", "5", "6"]]
    end

    it 'get_data_from_url' do
      VCR.use_cassette('example.csv') do
        expect(
          HeyDan::Helper.get_data_from_url('https://s3-us-west-1.amazonaws.com/heydan/spec/example.csv')
          ).to eq [["this is a csv", " with", " three columns"], ["1", " 2", " 3"], ["4", " 5", " 6"]]
      end
    end

  end

  context 'txt' do

    it 'get_data_from_url' do
      VCR.use_cassette('example.txt') do
        expect(
          HeyDan::Helper.get_data_from_url('https://s3-us-west-1.amazonaws.com/heydan/spec/example.txt')
          ).to eq [["this is a txt csv", " with", " three columns"], ["1", " 2", " 3"], ["4", " 5", " 6"]]
      end
    end

  end

  context 'zip' do

    it 'unzip' do
      expect(HeyDan::Helper.unzip(zip_example)).to eq ["spec/tmp/downloads/example.csv"]
    end

    it 'get_data_from_url' do
      VCR.use_cassette('example.zip') do
        expect(
          HeyDan::Helper.get_data_from_url('https://s3-us-west-1.amazonaws.com/heydan/spec/example.zip')
          ).to eq [["this is a csv", " with", " three columns"], ["1", " 2", " 3"], ["4", " 5", " 6"]]
      end
    end

  end

  it 'save_data' do
    expect(File.exists?('spec/tmp/datasets/love.csv')).to be false
    HeyDan::Helper.save_data('love', [['column1', 'column2'],[1,2]])
    expect(File.exists?('spec/tmp/datasets/love.csv')).to be true
    expect(CSV.read('spec/tmp/datasets/love.csv')).to eq [["column1", "column2"], ["1", "2"]]
  end

  it 'dataset_exists?' do
    expect(HeyDan::Helper.dataset_exists?('love')).to be false
    HeyDan::Helper.save_data('love', [['column1', 'column2'],[1,2]])
    expect(HeyDan::Helper.dataset_exists?('love')).to be true
  end

end
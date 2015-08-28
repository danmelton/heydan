require 'spec_helper'

describe HeyDan do
  
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
      expect(f.include?("spec/tmp/downloads/example.txt")).to eq true
    end
    VCR.use_cassette('example.csv') do
      expect(File.exist?('spec/tmp/downloads/example.csv')).to eq false
      f= HeyDan::Helper.download_file('https://s3-us-west-1.amazonaws.com/heydan/spec/example.csv', File.join(HeyDan.folders[:downloads], 'example.csv'))
      expect(File.exist?('spec/tmp/downloads/example.csv')).to eq true
      expect(f.include?("spec/tmp/downloads/example.csv")).to eq true
    end
    VCR.use_cassette('example.zip') do
      expect(File.exist?('spec/tmp/downloads/example.zip')).to eq false
      f = HeyDan::Helper.download_file('https://s3-us-west-1.amazonaws.com/heydan/spec/example.zip', File.join(HeyDan.folders[:downloads], 'example.zip'))
      expect(File.exist?('spec/tmp/downloads/example.zip')).to eq true
      expect(f.include?("spec/tmp/downloads/example.zip")).to eq true
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

  context 'shp' do

    it 'get_shapefile' do
      expect(HeyDan::Helper.get_shapefile(['tmp/spec/downloads/shapefile/something.shp'])).to eq "tmp/spec/downloads/shapefile/something.shp"
      expect(HeyDan::Helper.get_shapefile(['tmp/spec/downloads/shapefile/something.csv'])).to eq nil
    end

    it 'is_shapefile?' do
      expect(HeyDan::Helper.is_shapefile?(['tmp/spec/downloads/shapefile/something.shp'])).to be true
      expect(HeyDan::Helper.is_shapefile?(['tmp/spec/downloads/shapefile/something.csv'])).to be false
    end

    it 'get_shapefile_data' do
      shp_file_path = File.join('spec', 'tmp', 'downloads', HeyDan::Helper.md5_name('tl_2015_32_unsd.zip'))
      FileUtils.cp(File.join('spec', 'fixtures', 'tl_2015_32_unsd.zip'), shp_file_path)
      expect(HeyDan::Helper).to receive(:download).with('ftp://ftp2.census.gov/geo/tiger/TIGER2015/UNSD/tl_2015_32_unsd.zip').and_return shp_file_path
      data = HeyDan::Helper.get_data_from_url('ftp://ftp2.census.gov/geo/tiger/TIGER2015/UNSD/tl_2015_32_unsd.zip')
      expect(data.size).to eq 18
      expect(data[1][-1].keys).to eq [:type, :coordinates]
    end

  end

  context 'excel' do

    it 'get_excel_file' do
      expect(HeyDan::Helper.get_excel_file(['tmp/spec/downloads/excelfile/something.xls'])).to eq "tmp/spec/downloads/excelfile/something.xls"
      expect(HeyDan::Helper.get_excel_file(['tmp/spec/downloads/excelfile/something.xlsx'])).to eq "tmp/spec/downloads/excelfile/something.xlsx"
      expect(HeyDan::Helper.get_excel_file(['tmp/spec/downloads/excelfile/something.csv'])).to eq nil
    end

    it 'is_excel?(files)' do
      expect(HeyDan::Helper.is_excel?(['tmp/spec/downloads/shapefile/something.xls'])).to be true
      expect(HeyDan::Helper.is_excel?(['tmp/spec/downloads/shapefile/something.xlsx'])).to be true
      expect(HeyDan::Helper.is_excel?(['tmp/spec/downloads/shapefile/something.shp'])).to be false
      expect(HeyDan::Helper.is_excel?(['tmp/spec/downloads/shapefile/something.csv'])).to be false
    end

    it 'get_excel_data xls' do
      file_path = File.join('spec', 'tmp', 'downloads', HeyDan::Helper.md5_name('example.xls'))
      FileUtils.cp(File.join('spec', 'fixtures', 'example.xls'), file_path)
      expect(HeyDan::Helper).to receive(:download).with('http://love.com/example.xls').and_return file_path
      data = HeyDan::Helper.get_data_from_url('http://love.com/example.xls')
      expect(data).to eq [["header1", "header2", "header3"], [1.0, 2.0, 3.0], [1.0, 2.0, 3.0]]
    end

    it 'get_excel_data xlsx' do
      file_path = File.join('spec', 'tmp', 'downloads', HeyDan::Helper.md5_name('example.xlsx'))
      FileUtils.cp(File.join('spec', 'fixtures', 'example.xlsx'), file_path)
      expect(HeyDan::Helper).to receive(:download).with('http://love.com/example.xlsx').and_return file_path
      data = HeyDan::Helper.get_data_from_url('http://love.com/example.xlsx')
      expect(data).to eq [["header1", "header2", "header3"], [1.0, 2.0, 3.0], [1.0, 2.0, 3.0]]
    end


  end

  context 'zip' do

    it 'unzip' do
      expect(HeyDan::Helper.unzip(zip_example)[0].include?("spec/tmp/downloads/example.csv")).to eq true
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

  it 'get_data' do
    expect(File.exists?('spec/tmp/datasets/love.csv')).to be false
    HeyDan::Helper.save_data('love', [['column1', 'column2'],[1,2]])
    expect(File.exists?('spec/tmp/datasets/love.csv')).to be true
    expect(HeyDan::Helper.get_data('love')).to eq [["column1", "column2"], ["1", "2"]]
  end

  it 'dataset_exists?' do
    expect(HeyDan::Helper.dataset_exists?('love')).to be false
    HeyDan::Helper.save_data('love', [['column1', 'column2'],[1,2]])
    expect(HeyDan::Helper.dataset_exists?('love')).to be true
  end

end
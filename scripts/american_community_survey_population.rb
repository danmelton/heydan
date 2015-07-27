require File.join(Dir.pwd, 'lib', 'hey_dan')

class AmericanCommunitySurveyPopulation < HeyDan::Script
  def get_data
    api_key = 'c752f1c125b9e278df02dd84e54868ee767f67b0'
    geos = ['place', 'state', 'county']
    @transform_data = {}
    geos.each do |geo|
      ['2013', '2012', '2011', '2010'].each do |y|
          data = JSON.parse(open("http://api.census.gov/data/#{y}/acs5?get=NAME,B01001_001E&for=#{geo}:*&key=#{api_key}").read)
          data[1..-1].each do |d|
            ansi_id = d[3].nil? ? d[2] : d[2]+d[3]
            @transform_data[ansi_id] ||= []
            @transform_data[ansi_id] << d[1].to_i
          end
      end
    end
  end

  def transform_data
    @csv_final_data = @transform_data.map { |c| c[1].unshift(c[0])}
    @csv_final_data.unshift(['ansi_id', '2013', '2012', '2011', '2010'])
    super
  end

  def save_data
  #this method saves the file into downloads
    super
  end

  def update_files
    super
    @identifiers = HeyDan::Script.identifiers_hash('ansi_id')
    meta_data = JSON.parse(File.read(File.join(@settings[:datasets_folder], 'decennial_census_population.json')))
    require 'parallel'
    Parallel.map(@csv_final_data[1..-1], :in_processes=>3, :progress => "Processing #{@csv_final_data[1..-1].size} rows for american_community_survey_population") do |row|
      filename = @identifiers[row[0]]
      next if filename.nil?
      jf = HeyDan::JurisdictionFile.new(name: filename)
      data = {"name" => "Total Population", "dates" => ['2013', '2012', '2011', '2010'], "data" => row[1..-1].map { |x| x.to_i}}
      jf.add_dataset('population', 'american_community_survey_population', data)
      jf.save
    end
  end

end
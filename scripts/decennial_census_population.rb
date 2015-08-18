require File.join(Dir.pwd, 'lib', 'hey_dan')

class DecennialCensusPopulation < HeyDan::Script
  def get_data
    api_key = 'c752f1c125b9e278df02dd84e54868ee767f67b0'
    geos = ['place', 'state', 'county']
    @transform_data = {}
    geos.each do |geo|
      [['2010','P0010001'], ['2000','P001001'], ['1990','P0010001']].each do |y|
          data = JSON.parse(open("http://api.census.gov/data/#{y[0]}/sf1?key=#{api_key}&get=#{y[1]}&for=#{geo}:*").read)
          data[1..-1].each do |d|
            state = d[1].size==1 ? "0#{d[1]}" : d[1]
            ansi_id = d[2].nil? ? state : state+d[2]
            @transform_data[ansi_id] ||= []
            @transform_data[ansi_id] << d[0].to_i
          end
      end
    end
  end

  def transform_data
    @csv_final_data = @transform_data.map { |c| c[1].unshift(c[0])}
    @csv_final_data.unshift(['ansi_id', 2010, 2000, 1990])
    super
  end

  def save_data
  #this method saves the file into downloads
    super
  end

  def update_files
    super
    @identifiers = HeyDan::Script.identifiers_hash('ansi_id')
    meta_data = JSON.parse(File.read(File.join(@settings[:sources_folder], 'decennial_census_population.json')))
    require 'parallel'
    Parallel.map(@csv_final_data[1..-1], :in_processes=>3, :progress => "Processing #{@csv_final_data[1..-1].size} rows for decennial_census_population") do |row|
      filename = @identifiers[row[0]]
      next if filename.nil?
      jf = HeyDan::JurisdictionFile.new(name: filename)
      data = {"name" => "Total Population", "dates" => [2010, 2000, 1990], "data" => row[1..-1].map { |x| x.to_i}}
      jf.add_dataset('population', 'decennial_census_population', data)
      jf.save
    end
  end

end
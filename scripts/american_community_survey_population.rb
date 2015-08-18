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

end
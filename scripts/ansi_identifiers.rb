require File.join(Dir.pwd, 'lib', 'hey_dan')

class AnsiIdentifiers < HeyDan::Identifier
  def get_data
    file = HeyDan::Helpers::download('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true', @name, 'csv')
    @csv_final_data = CSV.read(file)
    super
  end

  def type
    'ansi_id'
  end

  def identifier_column
    'ansi_id'
  end

  def skip_process?
    j = JurisdictionFile.new(name:"ocd-division/country:us/state:wy/place:yoder")
    if j.exists? && !j.get_json['identifiers']['ansi_id'].nil? 
      puts "skipping ANSI Identifiers, looks like they are already loaded"
      return true
    else
      return false
    end
    
  end

  def transform_data
    @csv_final_data = @csv_final_data[1..-1].select { |c| !c[5].nil? }.map { |c| [c[0], c[5].split('-')[-1]]}
    @csv_final_data = @csv_final_data.unshift(['id', identifier_column])
    super
  end

end

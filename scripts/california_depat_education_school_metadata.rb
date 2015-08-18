require File.join(Dir.pwd, 'lib', 'hey_dan')

class CaliforniaDepatEducationSchoolMetadata < HeyDan::Script
  def get_data
    file = HeyDan::Helpers::download('ftp://ftp.cde.ca.gov/demo/schlname/pubschls.txt', @name, 'csv')
    contents = File.read(file, :encoding => 'utf-8').encode("UTF-8", :invalid=>:replace, :replace=>"").gsub('"',"")
    @csv_final_data = CSV.parse(contents, { :col_sep => "\t" })
    super
  end

  def transform_data
    @csv_final_data = @csv_final_data[1..-1].select { |x| x[0][7..-1]=='0000000'}
    @csv_final_data = @csv_final_data.map { |c| [c[1], c[19]]}
    @csv_final_data = @csv_final_data.select { |x| !x[0].nil? && !x[1].nil?}
    @csv_final_data.unshift(['ansi_id', 'website'])
    super
  end

  def save_data
  #this method saves the file into downloads
    super
  end

  def update_files
    if @csv_final_data.nil?
      @csv_final_data = CSV.read(File.join(@settings[:datasets_folder], "#{@name}.csv"))
    end
    id = @csv_final_data[0][0]
    @identifiers = HeyDan::Script.identifiers_hash(id)
    meta_data = JSON.parse(File.read(File.join(@settings[:sources_folder], "#{@name}.json")))
    # Parallel.map(@csv_final_data[1..-1], :in_processes=>3, :progress => "Processing #{@csv_final_data[1..-1].size} rows for #{@name}") do |row|
      @csv_final_data[1..-1].each do |row|
      filename = @identifiers[row[0]]
      next if filename.nil?
      if @jurisdiction_type
        next if !filename.include?(@jurisdiction_type)
      end
      jf = HeyDan::JurisdictionFile.new(name: filename)
      jf.add_property('website', row[1])
      jf.save
    end

  #this method loops through each item and saves it to the jurisdictions/entity_id 
    super
  end
end
class HeyDan::Identifier < HeyDan
  attr_accessor :name
  attr_accessor :jurisdiction_type
  attr_accessor :csv_final_data
  
  def initialize(opts={})
    super(opts)
    @name = opts[:name].downcase
    @jurisdiction_type = opts[:type]
    raise "#{@name} does not have a valid json file" if !valid_json?
  end

  def process
    return if skip_process?
    if !download_file_present?
      get_data
      transform_data
      save_data
    end
    update_files
  end

  def get_data
  end

  def transform_data
  end

  def skip_file?(jf=nil)
    false
  end

  def skip_process?
    false
  end

  def type
    "open_civic_id"
  end

  def identifier_column
    "id"
  end

  def update_files
    if @csv_final_data.nil?
      @csv_final_data = CSV.read(File.join(@settings[:datasets_folder], "#{@name}.csv"))
    end
    if @jurisdiction_type
      @csv_final_data = [@csv_final_data[0]] + @csv_final_data.select { |x| x[0].include?(@jurisdiction_type)}
    end

    header = @csv_final_data[0]
    Parallel.map(@csv_final_data[1..-1], :in_processes=>3, :progress => "Processing #{@csv_final_data[1..-1].size} identifiers for #{type} ") do |row|
      jf = HeyDan::JurisdictionFile.new(name: row[0])
      next if skip_file?(jf)
      id = header.index(identifier_column)
      next if row[id].nil?
      jf.add_identifier(type, row[id])
      add_other_data(jf, header, row)
      jf.save
    end 
  end

  def add_other_data(jurisdiction_file, header,row)
  end

  def save_data
    require 'csv'
    CSV.open(File.join(@settings[:datasets_folder], "#{@name}.csv"), 'w') do |csv|
      @csv_final_data.each do |row|
        csv << row
      end
    end
  end

  def valid_json?
    require 'json'
    begin
      json = File.read(File.join(@settings[:identifiers_folder], "#{@name}.json"))
      JSON.parse(json)  
    return true  
    rescue JSON::ParserError  
      return false  
    end  
  end

  def self.process(opts={})
    self.process_order.each do |name|
      if File.exist? File.join(settings[:scripts_folder], "#{name}.rb")
        load File.join(settings[:scripts_folder], "#{name}.rb")
        Object.const_get(HeyDan::Helpers.classify(name)).new({name: name, type: opts[:type]}).process
      else
        puts "Files for #{name} do not exist"
        next
      end
    end
  end

  def self.process_order
    ['open_civic_identifiers', 'ansi_identifiers']
  end

end
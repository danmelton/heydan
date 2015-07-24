require 'csv'
require 'open-uri'

class HeyDan::Script < HeyDan
  attr_accessor :name
  attr_accessor :tmp_file_path
  attr_accessor :download_file_path
  attr_accessor :transform_data
  attr_accessor :csv_final_data
  
  def initialize(opts={})
    super(opts)
    @name = opts[:name].downcase
    @dataset = HeyDan::Dataset.new({settings: @settings, name: @name})
    raise "#{@name} does not have a valid json file" if !@dataset.valid_json?
  end

  def process
    get_data
    transform_data
    save_data
    validate_process
    update_files
  end

  def self.identifiers_hash(identifier)
    identifier_file = File.join(SETTINGS[:tmp_folder], "identifiers_file_#{identifier}.json")
    if File.exist?(identifier_file)
      @identifier_hash = JSON.parse(File.read(identifier_file))
      return @identifier_hash
    end
    puts "building identifiers hash for #{identifier} to filenames, this might take a moment"
    @identifier_hash = {} 
    Dir.glob(File.join(SETTINGS[:jurisdictions_folder], '*.json')).each do |j|
      jf = HeyDan::JurisdictionFile.new(name: j.gsub(SETTINGS[:jurisdictions_folder] + '/', ''))
      @identifier_hash["#{jf.get_identifier('ansi_id')}"] = j.gsub(SETTINGS[:jurisdictions_folder] + '/', '')
    end
    File.open(identifier_file, 'w') do |file|
      file.write(@identifier_hash.to_json)
    end
    @identifier_hash
  end

  def get_data
  end

  def transform_data
  end

  def update_files
  end

  def save_data
    CSV.open(File.join(@settings[:downloads_folder], "#{@name}.csv"), 'w') do |csv|
      @csv_final_data.each do |row|
        csv << row
      end
    end
  end

  def validate_process
    raise "File did not save" if !File.exist?(File.join(@settings[:downloads_folder], "#{@name}.csv"))
    @csv = CSV.read(File.join(@settings[:downlads_folder], "#{@name}.csv")) rescue 'Could not open csv'
    raise 'CSV needs at least two rows' if @csv.size < 2 
  end

  def self.process(names=[])
    names.each do |name|
      if File.exist? File.join(settings[:scripts_folder], "#{name}.rb")
        load File.join(settings[:scripts_folder], "#{name}.rb")
        Object.const_get(HeyDan::Helpers.classify(name)).new(name: name).process
      else
        puts "Files for #{name} do not exist"
        next
      end
    end
  end

  def self.process_all
    puts "not yet implemented"
  end

end
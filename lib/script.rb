class HeyDan::Script < HeyDan
  attr_accessor :name
  attr_accessor :tmp_file_path
  attr_accessor :download_file_path
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
  end

  def get_data
  end

  def transform_data
  end

  def save_data
    require 'csv'
    CSV.open(File.join(@settings[:downloads_folder], "#{@name}.csv"), 'w') do |csv|
      @csv_final_data.each do |row|
        csv << row
      end
    end
  end

  def validate_process
    raise "File did not save" if !File.exist?(File.join(@settings[:downloads_folder], "#{@name}.csv"))
    require 'csv'
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
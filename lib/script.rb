require 'csv'
require 'open-uri'
require 'pry'
require 'parallel'

class HeyDan::Script < HeyDan
  attr_accessor :name
  attr_accessor :tmp_file_path
  attr_accessor :download_file_path
  attr_accessor :transform_data
  attr_accessor :csv_final_data
  attr_accessor :jurisdiction_type

  def initialize(opts={})
    super(opts)
    @name = opts[:name].downcase
    @jurisdiction_type = opts[:type]
    @dataset = HeyDan::Source.new({settings: @settings, name: @name})
    raise "#{@name} does not have a valid json file" if !@dataset.valid_json?
  end

  def process
    if !download_file_present?
      get_data
      transform_data
      save_data
      validate_process
    end
    update_files
  end

  def self.identifiers_hash(identifier)
    identifier_file = File.join(SETTINGS[:downloads_folder], "identifiers_file_#{identifier}.json")
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
    if @csv_final_data.nil?
      @csv_final_data = CSV.read(File.join(@settings[:datasets_folder], "#{@name}.csv"))
    end
    id = @csv_final_data[0][0]
    @identifiers = HeyDan::Script.identifiers_hash(id)
    meta_data = JSON.parse(File.read(File.join(@settings[:sources_folder], "#{@name}.json")))
    progress = ProgressBar.create(:title => "Updating Files with #{@name} for #{@csv_final_data[1..-1].size} jurisdictions", :starting_at => 0, :total => @csv_final_data[1..-1].size)
    @csv_final_data[1..-1].each do |row|
      filename = @identifiers[row[0]]
      next if filename.nil?
      if @jurisdiction_type
        next if !filename.include?(@jurisdiction_type)
      end
      jf = HeyDan::JurisdictionFile.new(name: filename)
      data = {"name" => meta_data["name"], "dates" => meta_data["dates"], "data" => row[1..-1].map { |x| x.to_i}}
      jf.add_dataset(meta_data["tag"], @name, data)
      jf.save
      progress.increment
    end
    progress.finish
  end

  def save_data
    CSV.open(File.join(@settings[:datasets_folder], "#{@name}.csv"), 'w') do |csv|
      @csv_final_data.each do |row|
        csv << row
      end
    end
  end

  def validate_process
    raise "File did not save" if !File.exist?(File.join(@settings[:datasets_folder], "#{@name}.csv"))
    @csv = CSV.read(File.join(@settings[:downlads_folder], "#{@name}.csv")) rescue 'Could not open csv'
    raise 'CSV needs at least two rows' if @csv.size < 2 
  end

  def self.process(opts={})
    opts[:names].each do |name|
      name.gsub!('.json', '') if name.include?('.json')
      puts "Getting Data for #{name}"

      if File.exist? File.join(settings[:scripts_folder], "#{name}.rb")
        load File.join(settings[:scripts_folder], "#{name}.rb")
        Object.const_get(HeyDan::Helpers.classify(name)).new(name: name).process
      else
        puts "Files for #{name} do not exist"
        next
      end
    end
  end

  #for really big files, we need to split them for parrallel processing
  #TODO, we'll need to make this command platform independent
  def split_files(original_filepath, lines=100000)
    system("split -l #{lines} #{original_filepath} #{original_filepath}_")
    Dir.glob("#{original_filepath}_*")
  end

  #TODO, we'll need to make this command platform independent
  def combine_files(filepath_glob, newfile_path)
    system("cat #{filepath_blog} > #{newfile_path}")
  end

  def clean_up(files)
    files.map { |x| File.delete(x)}
  end

  def self.process_all(opts={})
    opts[:names] = datasets
    process(opts)
  end

  def self.update_files(opts={})
    if opts[:names].size > 0
      @datasets = opts[:names]
    else
      @datasets = datasets
    end
    @datasets.each do |name|
      name.gsub!('.json', '') if name.include?('.json')
      if File.exist? File.join(settings[:scripts_folder], "#{name}.rb")
        load File.join(settings[:scripts_folder], "#{name}.rb")
        Object.const_get(HeyDan::Helpers.classify(name)).new({name: name, type: opts[:type]}).update_files
      else
        puts "Files for #{name} do not exist"
        next
      end
    end
  end


end
require 'ruby-progressbar'
class HeyDan::Script
  attr_accessor :jurisdiction_type
  attr_accessor :fromsource
  attr_accessor :data
  attr_accessor :folder
  attr_accessor :source
  attr_accessor :variable
  attr_accessor :id
  attr_accessor :source_file
  attr_accessor :identifiers #builds a hash with new_identifier => file_name

  def initialize(opts)
    @folder = opts[:folder]
    @source = opts[:source]
    @variable  = opts[:variable]
    @jurisdiction_type = HeyDan.options[:type]
    @fromsource = HeyDan.options[:fromsource]
    @identifiers = {}
    @source_file = HeyDan::SourceFile.new(@folder, @source, @variable)
  end

  #overwritten by the developer
  def build
  end

  #overwritten by the developer
  def validate_build
  end

  #overwritten by the developer, can be dataset, attribute, or identifer
  def type
    'dataset'
  end

  #overwritten by developer
  def version
    1
  end

  def dataset_file_name
    "#{@folder}_#{@source}_#{@variable}.csv"
  end

  def name
    "#{@folder}_#{@source}_#{@variable}.csv"
  end

  def dataset_file_path
    File.join(HeyDan.folders[:datasets], dataset_file_name)
  end

  #downloads from the cdn
  def download
    @data = HeyDan::Helper.get_data_from_url(HeyDan.cdn + '/' + dataset_file_name)
  end

  def process_from_source
    build
    validate_build
    HeyDan::Helper.save_data(dataset_file_name, @data)
  end

  #runs through download, build and validate
  def process
    if @fromsource
      puts "From Source is specified, processing from source for #{name}" if HeyDan.help?
      process_from_source 
    end

    begin
      if HeyDan::Helper.dataset_exists?(dataset_file_name)
        puts "Dataset for #{name} exists" if HeyDan.help?
      else
        download 
      end
    rescue 
        puts "Had trouble downloading #{name}, processing from source instead" if HeyDan.help?
        process_from_source        
    end      
    update_jurisdiction_files
  end

  def build_identifier_hash(identifier)
    identifier_file = File.join(HeyDan.folders[:downloads], "identifiers_file_#{identifier}.json")
    if File.exist?(identifier_file)
      @identifiers = JSON.parse(File.read(identifier_file))
      return @identifiers
    end
    HeyDan::HelpText.build_identifier(identifier)
    get_identifiers_from_files(identifier)
    File.open(identifier_file, 'w') do |file|
      file.write(@identifiers.to_json)
    end
    @identifiers
  end

  def get_identifiers_from_files(identifier)
    @identifiers = {} 
    Dir.glob(File.join(HeyDan.folders[:jurisdictions], '*.json')).each do |j|
      jf = HeyDan::JurisdictionFile.new(name: j.gsub(HeyDan.folders[:jurisdictions] + '/', ''))
      return if !jf.match_type?(@jurisdiction_type)
      @identifiers["#{jf.get_identifier(identifier)}"] = j.gsub(HeyDan.folders[:jurisdictions] + '/', '')
    end
    @identifiers
  end

  def update_jurisdiction_files
    get_data
    get_identifiers
    @progress = ProgressBar.create(:title => "Updating Files for #{@source} #{@variable} from #{@folder} for jurisdictions #{(' matching ' + @jurisdiction_type) if @jurisdiction_type}", :starting_at => 0, :total => @data[1..-1].size) if HeyDan.help?
    self.send("add_#{type}s")
    @progress.finish if HeyDan.help?
  end

  def add_datasets
    metadata = @source_file.variable
    metadata.keep_if { |k| ['id', 'name', 'short_description', 'tags'].include?(k)}
    metadata["years"] = @data[0][1..-1]
    id = metadata['id']
    @data[1..-1].each_index do |i| 
      row = @data[i+1]
      next if row[0].nil? || @identifiers[row[0]].nil?
      jf = get_jurisdiction_filename(@identifiers[row[0]])
      next if row[0].nil? || !jf.exists?
      ds = jf.get_dataset(id)
      if !ds.nil?
        if ds['version'] >= version
          @progress.progress = i if HeyDan.help?
          next
        end
      end
      jf.datasets.delete(ds)
      metadata["version"] = version
      metadata["data"] = row[1..-1]
      jf.add_dataset(metadata)
      jf.save
      @progress.progress = i if HeyDan.help?
    end
  end

  def get_jurisdiction_filename(id)
    HeyDan::JurisdictionFile.new(name: @identifiers[id] || id)
  end

  def add_identifiers
    @data[1..-1].each_index do |i| 
      row = @data[i+1]
      jf = get_jurisdiction_filename(row[0])
      next if row[0].nil? || !jf.exists?
      jf.add_identifier(@data[0][1], row[1])
      jf.save
      @progress.progress = i  if HeyDan.help?
    end
  end

  def add_attributes
    @data[1..-1].each_index do |i| 
        row = @data[i+1]
        jf = get_jurisdiction_filename(row[0])
        next if row[0].nil? || !jf.exists?
        jf.add_attribute(@data[0][1], row[1])
        jf.save
        @progress.progress = i  if HeyDan.help?
      end
  end

  def get_identifiers
    @id = @data[0][0]
    @identifiers = build_identifier_hash(@id)
  end

  def get_data
    if @data.nil?
      @data = HeyDan::Helper.get_data(dataset_file_name)
    end
  end

end
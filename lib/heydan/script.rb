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
    @jurisdiction_type = opts[:type]
    @fromsource = opts[:fromsource]
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

  def dataset_file_name
    "#{@folder}_#{@source}_#{@variable}.csv"
  end

  def dataset_file_path
    File.join(HeyDan.folders[:datasets], dataset_file_name)
  end

  #downloads from the cdn
  def download
    @data = HeyDan::Helper.get_data_from_url(HeyDan.cdn + dataset_file_name)
  end

  #runs through download, build and validate
  def process
    if @fromsource
      build
      validate_build
      HeyDan::Helper.save_data(dataset_file_name, @data)
    else
      download 
    end
    filter_jurisdiction_type
    update_jurisdiction_files
  end

  def build_identifier_hash(identifier)
    identifier_file = File.join(HeyDan.folders[:downloads], "identifiers_file_#{identifier}.json")
    if File.exist?(identifier_file)
      @identifier_hash = JSON.parse(File.read(identifier_file))
      return @identifier_hash
    end
    HeyDan::HelpText.build_identifier(identifier)
    get_identifiers_from_files
    File.open(identifier_file, 'w') do |file|
      file.write(@identifier_hash.to_json)
    end
    @identifier_hash
  end

  def get_identifiers_from_files
    @identifier_hash = {} 
    Dir.glob(File.join(HeyDan.folders[:jurisdictions], '*.json')).each do |j|
      jf = HeyDan::JurisdictionFile.new(name: j.gsub(HeyDan.folders[:jurisdictions] + '/', ''))
      @identifier_hash["#{jf.get_identifier('ansi_id')}"] = j.gsub(HeyDan.folders[:jurisdictions] + '/', '')
    end
    @identifier_hash
  end

  def filter_jurisdiction_type
  end

  def update_jurisdiction_files
    get_data
    get_identifiers
    self.send("add_#{type}s")
  end

  def add_datasets
    metadata = @source_file.variable
    metadata.keep_if { |k| ["id", "name", "short_description"].include?(k)}
    metadata["years"] = @data[0][1..-1]
    @data[1..-1].each do |row| 
      next if row[0].nil?
      jf = get_jurisdiction_filename(row[0])
      metadata["data"] = row[1..-1]
      index = jf.datasets.index(metadata)
      if !index.nil? 
        jf.datasets.delete_at(index)
      end
      jf.add_dataset(metadata)
      jf.save
    end
  end

  def get_jurisdiction_filename(id)
    HeyDan::JurisdictionFile.new(name: @identifiers[id] || id)
  end

  def add_identifiers
    @data[1..-1].each do |row| 
      jf = get_jurisdiction_filename(row[0])
      next if row[0].nil?
      jf.add_identifier(@data[0][1], row[1])
      jf.save
    end
  end

  def add_attributes
    @data[1..-1].each do |row| 
        jf = get_jurisdiction_filename(row[0])
        next if row[0].nil?
        jf.add_attribute(@data[0][1], row[1])
        jf.save
      end
  end

  def get_identifiers
    @id = @data[0][0]
    if @id!='open_civic_id'
      @identifiers = build_identifier_hash(@id)
    end
  end

  def get_data
    if @data.nil?
      @data = HeyDan::Helper.get_data(name)
    end
  end

end
class HeyDan::Script
  attr_accessor :jurisdiction_type
  attr_accessor :fromsource
  attr_accessor :data
  attr_accessor :folder
  attr_accessor :source
  attr_accessor :variable
  attr_accessor :id

  def initialize(opts)
    @folder = opts[:folder]
    @source = opts[:source]
    @variable  = opts[:variable]
    @jurisdiction_type = opts[:type]
    @fromsource = opts[:fromsource]
  end

  #overwritten by the developers
  def build
  end

  #overwritten by the developers
  def validate_build
  end

  #overwritten by the developers, can be dataset, attribute, or identifer
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
    validate_update
  end

  def build_identifiers_hash(identifier)
  end

  def filter_jurisdiction_type
  end

  def update_jurisdiction_files
    get_data
    get_identifiers
    self.send("add_#{type}s")
  end

  def validate_update
  end

  def add_datasets
  end

  def add_identifiers
  end

  def add_attributes
  end

  def add_properties
  end

  def get_identifiers
    @id = @data[0][0]
    if @id!='open_civic_id'
      @identifiers = build_identifiers_hash(@id)
    end
  end

  def get_data
    if @data.nil?
      @data = HeyDan::Helper.get_data(name)
    end
  end

end
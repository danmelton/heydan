class HeyDan::JurisdictionFile < HeyDan
  attr_accessor :name
  attr_accessor :json
  
  def initialize(opts={})
    @name = opts[:name]
    raise "Name is required" if @name.nil?
    super
  end

  def type
    @name.split('/')[-1].split(':')[0]
  end

  def file_name
    "#{@name.gsub(/\//, '::').gsub('ocd-division::', '')}.json"
  end

  def exists?
    File.exists?(file_path)
  end

  def folder_path
    File.join(Dir.pwd, @settings[:jurisdictions_folder])
  end

  def file_path
    File.join(folder_path, file_name)
  end

  def initial_json
    {'id' => @name, 'identifiers' => {}, 'datasets' => {}}
  end

  def add_identifier(key, value)
    get_json
    @json['identifiers'][key] = value
    @json
  end

  def add_dataset(tag, key, value)
    get_json
    @json['datasets'][tag] = {} if @json['datasets'][key].nil?
    @json['datasets'][tag][key] = value
    @json
  end

  def add_property(key, value)
     get_json
    @json[key] = value
    @json
  end

  def get_json
    if !exists?
      @json ||= initial_json 
    end
    return @json if @json
    @json = JSON.parse(File.read(file_path))
  end

  def save
      File.open(file_path, 'w') do |f|
        f.write(@json.to_json)
      end
  end

end
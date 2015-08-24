require 'json'

class HeyDan::JurisdictionFile
  attr_accessor :name
  attr_accessor :json
  
  def initialize(opts={})
    @name = opts[:name]
    convert_file_name if @name.include?('.json')
    @name = @name.gsub('jurisdictions/','').gsub('ocd-division/','').gsub(/\.\.\//,'')
    raise "Name is required" if @name.nil?
  end

  def type
    @name.split('/')[-1].split(':')[0]
  end

  def id
    get_json
    @json['id']
  end

  def match_type?(ocd_type)
    ocd_type.gsub!(':all', '.+')
    !id.match(/#{ocd_type}/).nil?
  end

  def convert_file_name
    @name = "#{@name.gsub('::','/').gsub('.json','')}"
  end

  def file_name
    "#{@name.gsub(/\//, '::').gsub('ocd-division::', '')}.json"
  end

  def hash_id
    HeyDan::Helper.md5_name(@name.gsub(/\.\.\//,''))
  end

  def exists?
    File.exists?(file_path)
  end

  def file_path
    File.join(HeyDan.folders[:jurisdictions], file_name)
  end

  def type
    @name.split('/')[-1].split(':')[0]
  end

  def initial_json
    {'id' => @name, 'entityType' => type, 'attributes'=> {}, 'identifiers' => {}, 'datasets' => []}
  end

  def get_identifier(key)
    get_json
    @json['identifiers'][key]
  end

  def add_identifier(key, value)
    get_json
    @json['identifiers'][key] = value
    @json
  end

  def add_dataset(value)
    get_json
    @json['datasets'] << value 
    @json
  end

  def get_dataset(key)
    get_json
    @json['datasets'].select { |d| d['id']==key}[0]
  end

  def datasets
    get_json
    @json['datasets']
  end

  def add_property(key, value)
    return false if ['datasets', 'identifiers', 'id', 'entityType', 'attributes'].include?(key)
     get_json
    @json[key] = value
    @json
  end

  def add_attribute(key, value)
     get_json
    @json['attributes'][key] = value
    @json
  end

  def get_attribute(key)
     get_json
    @json['attributes'][key]
  end

  def get_json
    if !exists?  
      @json ||= initial_json 
    else
      file = File.read(file_path)
      @json ||= initial_json if file == ""
    end
    return @json if @json
    @json = JSON.parse(file)
  end

  def save
    File.open(file_path, 'w') do |f|
      f.write(@json.to_json)
    end
  end

end
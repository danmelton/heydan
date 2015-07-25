require 'elasticsearch'

class HeyDan::ElasticSearch < HeyDan
  attr_accessor :current_mapping
  attr_accessor :client
  attr_accessor :index

  def initialize(opts={})
    super
    @client = Elasticsearch::Client.new host: opts[:url], log: false
    @index = opts[:index] || 'jurisdictions'
    @current_mapping = {}
  end

  def get_mapping
    if check_index
      mapping = @client.indices.get_mapping index: 'jurisdictions' 
      @current_mapping = mapping['jurisdictions']['mappings']
      @current_mapping
    end
  end

  def build_mapping
    #scan the directory
  end

  def update_mapping(type, block='data', properties={})
    raise "block must be properties or data" if !['properties', 'data'].include?(block)
    @current_mapping[type] = {'properties' => {}} if @current_mapping[type].nil?
    
    if block == 'properties'
      @current_mapping[type]['properties'].merge!(properties)
    else
      if @current_mapping[type]['properties'][block].nil?
        @current_mapping[type]['properties'][block] = {}
      end
      @current_mapping[type]['properties'][block].merge!(properties)
    end
    @current_mapping
  end

  def put_mapping(type)
    @client.indices.put_mapping index: @index, type: type, body: @current_mapping[type]
  end


  def check_index
    @client.indices.exists? index: @index
  end

  def create_index
    @client.indices.create index: @index
  end

  def import
    puts "Posting to Elasticsearch"
    total = Dir.glob("#{@settings[:jurisdictions_folder]}/*").size
    puts "Processing #{total} in #{@settings[:jurisdictions_folder]}"
    files= Dir.glob("#{@settings[:jurisdictions_folder]}/*")
    a=0
    b=1000
    while true do
      @bulk = []
      b=( files.size - b < 1000 ? -1 : a + 1000)
      files[a..b].each do |file|
        json = JSON.parse(File.read(file))
        @bulk << { index:  { _index: 'jurisdictions', _type: json['entityType'] | 'entity', data: json } } 
      end
      @client.bulk refresh: true, body: @bulk; nil    
      a = b + 1
      break if b == -1
    end
  end

end

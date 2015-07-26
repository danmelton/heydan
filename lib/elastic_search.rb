require 'elasticsearch'

class HeyDan::ElasticSearch < HeyDan
  attr_accessor :current_mapping_hash
  attr_accessor :current_mapping_array
  attr_accessor :client
  attr_accessor :index

  def initialize(opts={})
    super
    @client = Elasticsearch::Client.new host: opts[:url], log: false
    @index = opts[:index] || 'jurisdictions'
    @current_mapping = {}
    @current_mapping_array = []
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

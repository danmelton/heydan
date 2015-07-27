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
    files= Dir.glob("#{@settings[:jurisdictions_folder]}/*")
    a=0
    b=10000
    progress = ProgressBar.create(:title => "Importing #{files.size} jurisdictions into Elastic Search", :starting_at => a, :total => files.size)
    while true do
      @bulk = []
      b=( files.size - b < 10000 ? -1 : a + 10000)
      files[a..b].each do |file|
        jf = HeyDan::JurisdictionFile.new(name: file)
        @bulk << { index:  { _index: 'jurisdictions', _type: jf.type, data: jf.get_json } } 
      end
      @client.bulk refresh: true, body: @bulk; nil    
      a = b + 1
      if b == -1
        progress.finish
        break 
      else
        progress.progress = a 
      end
    end
  end

end

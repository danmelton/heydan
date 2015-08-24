require 'ruby-progressbar'
require 'elasticsearch'

class HeyDan::Import
    attr_accessor :client

    class << self
      def client
        @client ||= Elasticsearch::Client.new host: HeyDan.elasticsearch[:url], log: false
      end

      def index
        @index ||= 'jurisdictions'
      end

      def check_index
        @client.indices.exists? index: index
      end

      def create_index
        @client.indices.create index: index
      end

      def process
        create_index unless check_index
        total = Dir.glob("#{HeyDan.folders[:jurisdictions]}/*").size
        files= Dir.glob("#{HeyDan.folders[:jurisdictions]}/*")
        a=0
        b=10000
        progress = ProgressBar.create(:title => "Importing #{files.size} jurisdictions into Elastic Search", :starting_at => a, :total => files.size)
        while true do
          @bulk = []
          b=( files.size - b < 10000 ? -1 : a + 10000)
          files[a..b].each do |file|
            jf = HeyDan::JurisdictionFile.new(name: file)
            @bulk << { index:  { _index: 'jurisdictions', _type: jf.type, _id: jf.hash_id, data: jf.get_json } } 
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
end
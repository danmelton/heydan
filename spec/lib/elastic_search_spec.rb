require 'spec_helper'

describe HeyDan::ElasticSearch do

  context 'initialize' do

    it 'sets sets client' do
      expect(!HeyDan::ElasticSearch.new.client.nil?).to eq true
    end

    it 'sets the host' do
      expect(HeyDan::ElasticSearch.new.client.transport.hosts).to eq  [{:host=>"localhost", :port=>"9200", :protocol=>"http"}]
      expect(HeyDan::ElasticSearch.new(url: 'http://love.com:9200').client.transport.hosts).to eq  [{:scheme=>"http", :user=>nil, :password=>nil, :host=>"love.com", :path=>"", :port=>"9200", :protocol=>"http"}]
    end

    it 'sets the index' do
      expect(HeyDan::ElasticSearch.new.index).to eq 'jurisdictions'
      expect(HeyDan::ElasticSearch.new(index: 'love').index).to eq 'love'
    end

  end

  context 'methods' do
    before do
      @es = HeyDan::ElasticSearch.new
    end

    it 'check_index false' do
      VCR.use_cassette("check_index_false") do
        expect(@es.check_index).to eq false
      end
    end

    it 'check_index true' do
      VCR.use_cassette("check_index_true") do
        expect(@es.check_index).to eq true
      end
    end

    it 'creates index' do
      VCR.use_cassette('create_index') do
        @es.create_index
      end
    end  
  end

  
end
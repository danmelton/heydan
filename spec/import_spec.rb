require 'spec_helper'

describe HeyDan::Import do
  let(:import) {HeyDan::Import}

  context 'initialize' do

    it 'sets sets client' do
      expect(!import.client.nil?).to eq true
    end

    it 'sets the host' do
      expect(import.client.transport.hosts).to eq  [{:scheme=>"http", :user=>nil, :password=>nil, :host=>"localhost", :path=>"", :port=>9200, :protocol=>"http"}]
    end

    it 'sets the index' do
      expect(import.index).to eq 'jurisdictions'
    end

  end

  context 'methods' do
    before do
      @es = import
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
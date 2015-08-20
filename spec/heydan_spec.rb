require 'spec_helper'

describe HeyDan do
  before do
    HeyDan.folders = {:jurisdictions=>"jurisdictions", 
        :sources=>"sources", :downloads=>"downloads"}
  end

  it 'has a version number' do
    expect(HeyDan::VERSION).not_to be nil
  end

  context 'default settings' do
    it 'help' do
      expect(HeyDan.help).to be true
    end

    it 'folders' do
      expect(HeyDan.folders).to eq ({:jurisdictions=>"jurisdictions", 
        :sources=>"sources", :downloads=>"downloads"})
    end
  end

  context 'update settings' do
    before do
      HeyDan::help = false
      HeyDan::folders = {}
    end
    
    it 'help' do
      expect(HeyDan::help).to be false
    end

    it 'folders' do
      expect(HeyDan::folders).to eq ({})
    end
  end

  it 'help text' do
    HeyDan.help = true
    expect(HeyDan.helper_text('setup')).to eq HeyDan::HelpText.setup
  end

end

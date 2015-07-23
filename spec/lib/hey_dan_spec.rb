require 'spec_helper'

describe HeyDan do
  before do
    @heydan = HeyDan.new(settings: HEYDANSETTINGS)
  end

  it 'requires files' do
    expect(HeyDan::Dataset).to eq HeyDan::Dataset
  end

  it 'loads settings' do
    expect(@heydan.settings).to eq ({:elasticsearch=>"http://localhost:9200", :tmp_folder=>"/Users/danielmelton/projects/heydan/spec/tmp/tmp", :jurisdictions_folder=>"/Users/danielmelton/projects/heydan/spec/tmp/jurisdictions", :downloads_folder=>"/Users/danielmelton/projects/heydan/spec/tmp/downloads", :scripts_folder=>"/Users/danielmelton/projects/heydan/spec/tmp/scripts", :datasets_folder=>"/Users/danielmelton/projects/heydan/spec/tmp/datasets"}
)
    expect(HeyDan.new(settings: {url: 'love.com'}).settings).to eq ({url: 'love.com'})
  end

  it 'changes settings' do
    heydan = HeyDan.new(settings: {url: 'love.com'})
    expect(heydan.settings).to eq ({url: 'love.com'})
    heydan.settings[:url] = 'lover.com'
    expect(heydan.settings).to eq ({url: 'lover.com'})
  end


end
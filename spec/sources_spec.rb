require 'spec_helper'

describe HeyDan::Sources do

  it "checks to see if source is present" do
    expect(HeyDan::Sources.source_exists?('love')).to eq false
    expect(HeyDan::Sources.source_exists?('git@github.com:love/love.git')).to eq false
    expect(HeyDan::Sources.source_exists?('heydan_sources')).to eq true
    expect(HeyDan::Sources.source_exists?('git@github.com:danmelton/heydan_sources.git')).to eq true
  end

  it "adds the source to the settings file" do
    HeyDan::Sources.add('git@github.com:love/love.git')
    expect(HeyDan::Sources.source_exists?('love')).to eq true
    expect(HeyDan::Sources.source_exists?('git@github.com:love/love.git')).to eq true
  end

  it "extract_name from git link" do
    expect(HeyDan::Base).to receive(:save_settings).and_return true
    expect(HeyDan::Sources.extract_name('git@github.com:danmelton/heydan_sources.git')).to eq 'heydan_sources'
  end

end
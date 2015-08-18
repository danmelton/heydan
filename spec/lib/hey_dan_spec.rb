require 'spec_helper'

describe HeyDan do
  before do
    @heydan = HeyDan.new()
  end

  it 'requires files' do
    expect(HeyDan::Source).to eq HeyDan::Source
  end

  it 'loads settings' do
    expect(@heydan.settings.keys).to eq ["elasticsearch", "scripts_folder", "jurisdictions_folder", "sources_folder", "datasets_folder", "downloads_folder", "identifiers_folder", "aws_access_id", "aws_secret_key", "aws_bucket", "aws_region", "cdn"]
  end
  

end
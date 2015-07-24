require 'spec_helper'

describe HeyDan do
  before do
    @heydan = HeyDan.new()
  end

  it 'requires files' do
    expect(HeyDan::Dataset).to eq HeyDan::Dataset
  end

  it 'loads settings' do
    expect(@heydan.settings).to eq ({"elasticsearch"=>"http://localhost:9200", "scripts_folder"=>"spec/tmp/scripts", "jurisdictions_folder"=>"spec/tmp/jurisdictions", "downloads_folder"=>"spec/tmp/downloads", "tmp_folder"=>"spec/tmp", "datasets_folder"=>"spec/tmp/datasets", "identifiers_folder"=>"spec/tmp/identifiers"})
  end
  

end
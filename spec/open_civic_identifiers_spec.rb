require 'spec_helper'

describe HeyDan::OpenCivicIdentifiers do
  let(:heydan) {HeyDan::OpenCivicIdentifiers}
  before do
    ENV['HEYDAN_SETTINGS'] = File.join(Dir.pwd, 'spec', 'fixtures', 'settings.yml') 
  end

  it "sets the type" do
    heydan.build({type: 'school_district' })
    expect(heydan.jurisdiction_type).to eq 'school_district'
  end

  it 'check_folders' do
    heydan.build
    expect(Dir.exist?('spec/tmp')).to be true
    expect(heydan.jurisdictions_folder).to eq "spec/tmp/jurisdictions"
  end

  after do
    ENV['HEYDAN_SETTINGS'] = nil
  end

end
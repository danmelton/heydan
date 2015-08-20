require 'spec_helper'

describe HeyDan::OpenCivicIdentifiers do
  let(:heydan) {HeyDan::OpenCivicIdentifiers}

  it "build" do
    expect(HeyDan::Helper).to receive(:download).with('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true').and_return(File.join('spec','fixtures','open_civic_identifiers.csv'))
    heydan.build({type: 'school_district' })
    expect(heydan.jurisdiction_type).to eq 'school_district'
    expect(heydan.jurisdictions_folder.include?("spec/tmp/jurisdictions")).to eq true
    expect(Dir.glob("spec/tmp/jurisdictions/*").size).to eq 1
  end
end
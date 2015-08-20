require 'spec_helper'

describe HeyDan::Base do

  before do
    HeyDan.folders = {
      jurisdictions: 'jurisdictions',
      sources: 'sources',
      downloads: 'downloads' 
    }
  end

  let(:dir) {File.join('spec', 'tmp')}

  it 'setups_folders' do
    expect(HeyDan::folders).to eq ({:jurisdictions=>"jurisdictions", :sources=>"sources", :downloads=>"downloads"})
    HeyDan::Base.setup_folders(dir)
    expect(HeyDan::folders).to eq ({:jurisdictions=>"#{dir}/jurisdictions", :sources=>"#{dir}/sources", :downloads=>"#{dir}/downloads"})
  end

  it 'setup_dir' do
    expect(Dir.exist? dir).to be false
    HeyDan::Base.setup_dir(dir)
    expect(Dir.exist? dir).to be true
  end

  it 'create_settings_file' do
    settings_file = File.join(dir, 'heydan_settings.yml')
    expect(File.exist?(settings_file)).to be false
    HeyDan::Base.create_settings_file(dir)
    expect(File.exist?(settings_file)).to be true
    expect(YAML.load(File.read(settings_file))).to eq ({:help=>true, :folders=>{:jurisdictions=>"spec/tmp/jurisdictions", :sources=>"spec/tmp/sources", :downloads=>"spec/tmp/downloads"}})
    FileUtils.rm settings_file
  end

  it 'load_settings_file' do
    HeyDan::Base.create_settings_file(dir)
    HeyDan::folders = {
      jurisdictions: 'jurisdictions',
      sources: 'sources',
      downloads: 'downloads' 
    }
    expect(HeyDan::folders).to eq ({:jurisdictions=>"jurisdictions", :sources=>"sources", :downloads=>"downloads"})
    HeyDan::Base.load_settings_file(dir)
    expect(HeyDan::folders).to eq ({:jurisdictions=>"#{dir}/jurisdictions", :sources=>"#{dir}/sources", :downloads=>"#{dir}/downloads"})
  end

  it 'create_folders' do
    HeyDan::Base.setup_folders(dir)
    HeyDan::folders.keys.each do |folder|
      expect(Dir.exist?(HeyDan::folders[folder])).to be false
    end
    HeyDan::Base.create_folders
    HeyDan::folders.keys.each do |folder|
      expect(Dir.exist?(HeyDan::folders[folder])).to be true
    end
  end

  after do
    HeyDan::folders.keys.each do |folder|
      FileUtils.rm_rf dir if Dir.exist?(dir)
    end
  end


end
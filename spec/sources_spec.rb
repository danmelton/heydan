require 'spec_helper'

describe HeyDan::Sources do

  it "checks to see if source is present" do
    expect(HeyDan::Sources.source_exists?('love')).to eq false
    expect(HeyDan::Sources.source_exists?('https://github.com/love/love.git')).to eq false
    expect(HeyDan::Sources.source_exists?('heydan_sources')).to eq true
    expect(HeyDan::Sources.source_exists?('https://github.com/danmelton/heydan_sources.git')).to eq true
    HeyDan.sources.delete('love')
  end

  it "adds the source to the settings file" do
    HeyDan.sources = {}
    HeyDan.settings_file = File.join('spec','tmp', 'heydan_settings.yml')
    expect(HeyDan::Sources.source_exists?('love')).to eq false
    expect(HeyDan::Sources.source_exists?('https://github.com/love/love.git')).to eq false
    expect(HeyDan::Base).to receive(:save_settings).and_return true
    expect(HeyDan::Sources).to receive(:update).with('love').and_return true
    HeyDan::Sources.add('https://github.com/love/love.git')
    expect(HeyDan::Sources.source_exists?('love')).to eq true
    expect(HeyDan::Sources.source_exists?('https://github.com/love/love.git')).to eq true
    HeyDan.sources.delete('love')
  end

  it "extract_name from git link" do
    expect(HeyDan::Sources.extract_name('https://github.com/danmelton/heydan_sources.git')).to eq 'heydan_sources'
  end

  context 'update' do
    it 'clone' do
      expect(HeyDan::Sources.directory_exist?('heydan_sources')).to eq false
      expect(Git).to receive(:clone).with("https://github.com/danmelton/heydan_sources.git", "heydan_sources", {:path=>"spec/tmp/sources"}).and_return true
      HeyDan::Sources.update('heydan_sources')
    end

    it 'pull' do
      FileUtils.mkdir_p('spec/tmp/sources/heydan_sources/.git')
      expect(HeyDan::Sources.directory_exist?('heydan_sources')).to eq true
      expect(Git).to receive(:open).with("spec/tmp/sources/heydan_sources").and_return instance_double("Git::Base", :pull => true)      
      HeyDan::Sources.update('heydan_sources')
    end
  end

  it 'sync' do
    expect(HeyDan::Sources).to receive(:update).with('heydan_sources').and_return true
    HeyDan::Sources.sync
  end

  it 'correct_link?' do
    expect(HeyDan::Sources.correct_link?('http://github.com/danmelton/heydan_sources.git')).to be true
    expect(HeyDan::Sources.correct_link?('http://github.com/heydan_sources.git')).to be true
    expect(HeyDan::Sources.correct_link?('https://github.com/heydan_sources.git')).to be true
    expect(HeyDan::Sources.correct_link?('http://github/danmelton/heydan_sources.git')).to be false
  end


  context 'create' do

    context 'source does not exist' do

      it 'create' do
        expect(HeyDan::Sources).to receive(:directory_exist?).with('heydan_sources').and_return false
        expect(HeyDan::Sources).to receive(:source_exist?).with('heydan_sources', 'us_census').and_return false
        expect(HeyDan::Sources).to receive(:variable_exist?).with('heydan_sources', 'us_census', 'total_population').and_return false
        expect(HeyDan::Sources).to receive(:create_folder).with('heydan_sources').and_return true
        expect(HeyDan::Sources).to receive(:create_source).with('heydan_sources', 'us_census').and_return true
        expect(HeyDan::Sources).to receive(:create_variable).with('heydan_sources', 'us_census', 'total_population').and_return true
        HeyDan::Sources.create('heydan_sources', 'us_census', 'total_population')
      end

      it 'create_folder' do
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be false
        HeyDan::Sources.create_folder('heydan_sources')
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be true
      end

      it 'create_source' do
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be false
        HeyDan::Sources.create_source('heydan_sources', 'census')
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be true
        expect(HeyDan::Sources.source_exist?('heydan_sources', 'census')).to be true
      end

      it 'create_variable' do
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be false
        HeyDan::Sources.create_variable('heydan_sources', 'census', 'population')
        expect(HeyDan::Sources.directory_exist?('heydan_sources')).to be true
        expect(HeyDan::Sources.source_exist?('heydan_sources', 'census')).to be true
        expect(HeyDan::Sources.variable_exist?('heydan_sources', 'census', 'population')).to be true
      end
    end
  end

  context 'build' do
    it 'folder, name, variable' do
      expect(HeyDan::Sources).to receive(:build_variable).with('heydan_sources', 'census', 'population').and_return true
      HeyDan::Sources.build('heydan_sources', 'census', 'population')
    end

    it 'folder, name' do
      expect(HeyDan::Sources).to receive(:build_source).with('heydan_sources', 'census').and_return true
      HeyDan::Sources.build('heydan_sources', 'census')
    end

    it 'folder' do
      expect(HeyDan::Sources).to receive(:build_folder).with('heydan_sources').and_return true
      HeyDan::Sources.build('heydan_sources')
    end

    it 'blank' do
      expect(HeyDan::Sources).to receive(:build_folder).with('heydan_sources').and_return true
      HeyDan::Sources.build
    end

    it 'build_folder' do
      HeyDan::Sources.create_variable('heydan_sources', 'census', 'population')
      expect(HeyDan::Sources).to receive(:build_source).with('heydan_sources', 'census').and_return true
      HeyDan::Sources.build_folder('heydan_sources')
    end

    it 'build_source' do
      HeyDan::Sources.create_variable('heydan_sources', 'census', 'population')
      expect(HeyDan::Sources).to receive(:build_variable).with('heydan_sources', 'census', 'population').and_return true
      HeyDan::Sources.build_source('heydan_sources', 'census')
    end


  end


end
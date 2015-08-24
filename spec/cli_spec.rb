require 'spec_helper'
require 'fileutils'

describe HeyDan::Cli do
  before do
    HeyDan::help = false
  end

  context 'setup' do

    it 'class HeyDan Setup with folder' do
      expect(HeyDan::Base).to receive(:setup).with('spec/tmp').and_return true
      HeyDan::Cli.start(['setup', 'spec/tmp'])
    end

    it 'class HeyDan Setup without a folder' do
      expect(HeyDan::Base).to receive(:setup).with(nil).and_return true
      HeyDan::Cli.start(['setup'])
    end

  end

  context 'build' do

    it 'HeyDan calls OpenCivicIdentifiers.build' do
      expect(HeyDan::OpenCivicIdentifiers).to receive(:build).and_return true
      HeyDan::Cli.start(['build'])
    end

  end

  context "sources" do

    it 'sync calls Sources.sync' do
      expect(HeyDan::Sources).to receive(:sync).and_return true
      HeyDan::Cli.start(['sources', 'sync'])
    end

    it 'add calls Sources.add' do
      expect(HeyDan::Sources).to receive(:add).with('git@github.com:danmelton/heydan_sources.git').and_return true
      HeyDan::Cli.start(['sources', 'add', 'git@github.com:danmelton/heydan_sources.git'])
    end

    it 'update calls Sources.update' do
      expect(HeyDan::Sources).to receive(:update).with('heydan_sources').and_return true
      HeyDan::Cli.start(['sources', 'update', 'heydan_sources'])
    end

  end

  context 'new' do

    it 'calls Sources.create with just a folder and name' do
      expect(HeyDan::Sources).to receive(:create).with("heydan_sources", "census",  nil).and_return true
      HeyDan::Cli.start(['sources', 'new', 'heydan_sources', 'census', nil])
    end

    it 'calls Sources.create with a name and variable' do
      expect(HeyDan::Sources).to receive(:create).with("heydan_sources", "census",  "population").and_return true
      HeyDan::Cli.start(['sources', 'new', 'heydan_sources', 'census', 'population'])
    end
  end

  context 'build' do
    it 'calls Sources.build with just a folder and name' do
      expect(HeyDan::Sources).to receive(:build).with("heydan_sources", "census",  nil).and_return true
      HeyDan::Cli.start(['sources', 'build', 'heydan_sources', 'census', nil])
    end

    it 'calls Sources.build with a name and variable' do
      expect(HeyDan::Sources).to receive(:build).with("heydan_sources", "census",  "population").and_return true
      HeyDan::Cli.start(['sources', 'build', 'heydan_sources', 'census', 'population'])
    end

    it 'calls Sources.build with a name and variable and type/from-source' do
      expect(HeyDan::Sources).to receive(:build).with("heydan_sources", "census", "population").and_return true
      HeyDan::Cli.start(['sources', 'build', 'heydan_sources', 'census', 'population', '--type',  'school_district', '--fromsource'])
      expect(HeyDan.options).to eq ({"type"=>"school_district", "fromsource"=>true})
    end

  end

  context 'import' do
    it 'calls Import.process' do
      expect(HeyDan::Import).to receive(:process).with(no_args).and_return true
      HeyDan::Cli.start(['import'])
    end
  end

end

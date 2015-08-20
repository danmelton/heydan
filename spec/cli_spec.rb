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

    it 'class HeyDan Setup with folder' do
      expect(HeyDan::OpenCivicIdentifiers).to receive(:build).with({}).and_return true
      HeyDan::Cli.start(['build'])
    end

  end


end

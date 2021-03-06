$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'heydan'
require 'pry'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

def clean_tmp_folder
  FileUtils.rm_rf Dir.glob('spec/tmp/downloads/*')
  FileUtils.rm_rf Dir.glob('spec/tmp/datasets/*')
  FileUtils.rm_rf Dir.glob('spec/tmp/jurisdictions/*')
  FileUtils.rm_rf Dir.glob('spec/tmp/sources/*')
end

RSpec.configure do |config|
  config.after(:each) do
    clean_tmp_folder
  end
  config.before(:each) do
    HeyDan.settings_file = 'spec/fixtures/settings.yml'
    HeyDan::Base.load_settings_file(HeyDan.settings_file)
    clean_tmp_folder
  end
end

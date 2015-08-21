$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'heydan'
require 'pry'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :webmock
end

def clean_tmp_folder
  FileUtils.rm Dir.glob('spec/tmp/downloads/*')
  FileUtils.rm Dir.glob('spec/tmp/datasets/*')
  FileUtils.rm Dir.glob('spec/tmp/jurisdictions/*')
end

RSpec.configure do |config|
  config.after(:each) do
    clean_tmp_folder
  end
  config.before(:each) do
    HeyDan.settings_file = 'spec/heydan_settings.yml'
    HeyDan.folders = {
      jurisdictions: 'spec/tmp/jurisdictions',
      sources: 'spec/tmp/sources',
      downloads: 'spec/tmp/downloads',
      datasets: 'spec/tmp/datasets'
    }
    clean_tmp_folder
  end
end

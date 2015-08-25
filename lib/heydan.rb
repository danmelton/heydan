
module HeyDan

  class << self
    attr_accessor :help
    attr_accessor :folders
    attr_accessor :sources
    attr_accessor :settings_file
    attr_accessor :cdn
    attr_accessor :options
    attr_accessor :elasticsearch
    attr_accessor :aws_access_id
    attr_accessor :aws_secret_key
    attr_accessor :aws_bucket
    attr_accessor :aws_region

    #calls help text when needed
    def helper_text(method)
      if self.help
        HeyDan::HelpText.send(method)
      end
    end
  end

    self.settings_file = nil

    self.help = true
    
    def self.help?
      self.help
    end

    self.folders ||= {
      jurisdictions: 'jurisdictions',
      sources: 'sources',
      downloads: 'downloads',
      datasets: 'datasets'
    }

    self.sources = {
      heydan_sources: 'https://github.com/danmelton/heydan_sources.git'
    }

    self.cdn = 'https://heydan.s3-us-west-1.amazonaws.com'

    self.options = {}
    self.elasticsearch = {url: 'http://localhost:9200'}
end

require_relative "heydan/version"
require_relative "heydan/base"
require_relative "heydan/help_text"
require_relative "heydan/helper"
require_relative "heydan/script"
require_relative "heydan/script_file"
require_relative "heydan/source_file"
require_relative "heydan/jurisdiction_file"
require_relative "heydan/open_civic_identifiers"
require_relative "heydan/sources"
require_relative "heydan/import"
require_relative "heydan/server"
require_relative "heydan/cli"

HeyDan::Base.load_or_create_settings
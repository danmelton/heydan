
module HeyDan

  class << self
    attr_accessor :help
    attr_accessor :folders
    attr_accessor :sources
    attr_accessor :settings_file
    attr_accessor :cdn
    #calls help text when needed
    def helper_text(method)
      if self.help
        HeyDan::HelpText.send(method)
      end
    end
  end

    self.settings_file = nil

    self.help = true
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
require_relative "heydan/cli"

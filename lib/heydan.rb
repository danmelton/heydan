
module HeyDan

  class << self
    attr_accessor :help
    attr_accessor :folders
    #calls help text when needed
    def helper_text(method)
      if self.help
        HeyDan::HelpText.send(method)
      end
    end
  end

    self.help = true
    self.folders ||= {
      jurisdictions: 'jurisdictions',
      sources: 'sources',
      downloads: 'downloads' 
    }

end

require_relative "heydan/version"
require_relative "heydan/base"
require_relative "heydan/help_text"
require_relative "heydan/cli"

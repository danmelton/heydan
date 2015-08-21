require 'thor'

module HeyDan

  class Source < Thor

    desc "sync", "sync your sources in the settings file"
    def sync()
      HeyDan::helper_text('sources_sync')
      HeyDan::Sources.sync
    end

    desc "add GITHUB_LINK", "Add a new source directory from github"
    def add(github_link)
      HeyDan::helper_text('sources_add')
      HeyDan::Sources.add(github_link)
    end

    desc "update NAME", "update a source"
    def update(name)
      HeyDan::helper_text('sources_update')
      HeyDan::Sources.update(name)
    end

  end

  class Cli < Thor
    class_option 'type'

    desc "setup DIR", "Setups HeyDan in the current directory or specified DIR"
    def setup(dir=nil)
      HeyDan::helper_text('setup')
      HeyDan::Base.setup(dir)
    end

    desc "build", "Builds jurisdiction files"
    def build()
      HeyDan::helper_text('build')
      HeyDan::OpenCivicIdentifiers.build(options)
    end

    desc "sources SUBCOMMAND ...ARGS", "manage sources"
    subcommand "sources", Source
  end


end
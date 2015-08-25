require 'thor'

module HeyDan

  class Source < Thor

    desc "sync", "sync your sources folders from the settings file"
    def sync()
      HeyDan::helper_text('sources_sync')
      HeyDan::Sources.sync
    end

    desc "add GITHUB_LINK", "Add a new folder of sources from github"
    def add(github_link)
      HeyDan::helper_text('sources_add')
      HeyDan::Sources.add(github_link)
    end

    desc "update NAME", "update a folder of sources"
    def update(name)
      HeyDan::helper_text('sources_update')
      HeyDan::Sources.update(name)
    end

    desc "new FOLDER SOURCE VARIABLE", "adds a new source NAME in the FOLDER, and an optional VARIABLE"
    def new(folder, name, variable=nil)
      HeyDan::helper_text('sources_new')
      HeyDan::Sources.create(folder, name, variable)
    end

    option :fromsource, type: :boolean
    desc "build FOLDER NAME VARIABLE", "builds a source's variables in FOLDER, or optional VARIABLE. You can pass --type school_district for a specific jurisdiction type, or --from-source to build original files"
    def build(folder=nil, name=nil, variable=nil)
      HeyDan::helper_text('sources_build')
      HeyDan.options = options
      HeyDan::Sources.build(folder, name, variable)
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
      HeyDan.options = options
      HeyDan::OpenCivicIdentifiers.build
    end
    desc 'import', "Imports files into elasticsearch"
    def import()
      HeyDan::helper_text('import')
      HeyDan::Import.process
    end
    
    desc "sources SUBCOMMAND ...ARGS", "manage sources"
    subcommand "sources", Source
    
    desc "server", "starts up the webserver for heydan"
    def server()
      puts "Serving up some HeyDan Realness"
      HeyDan::Server.run!
    end  

  end

    

end
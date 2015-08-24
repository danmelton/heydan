class HeyDan::HelpText
  class << self
    def setup(opts={}) 
      return if !HeyDan.help?
      puts %Q(
          Hi! Adding a jurisdictions, datasets, downloads and sources directory and a settings.yml file. If you want to move these directories to other places, just update their locations in the settings file. 

          If you want to run heydan from a different folder than the settings.yml, create an environment variable:

          export HEYDAN_SETTINGS = full/path/to/settings.yml

          To turn off this help, run 'heydan help off' or set the help in settings to false.

          heydan grabs datasets and information about jurisdictions. If you want to focus on just one type of jurisdiction, update the settings 'jurisdiction_type'. Or you can pass --type school_district to any heydan command.

          Next, run `heydan build` to setup your files.
      )
  end

  def build(opts={})
    return if !HeyDan.help?
    type = opts[:type] || 'all'
    puts %Q(
      Woot, building files for type #{type} jurisdictions/. You will see a progress bar below. If you didn't specify a type, it might take a while. 

      heydan uses the Open Civic Identifiers format to structure file names and main identification for jurisdictions. This helps create a unique nonchanging identification code for every jurisdiction, based on the sponsoring parent. So, the State of Kansas, would be country:us/state:kansas. heydan creates a flat json file for each jurisdiction, which you can then import into your own application or elasticsearch.

      Next, run heydan sources sync
      )
  end

  def sources_add
    return if !HeyDan.help?
    puts %Q(
      You can leverage the community of developers out there. Add the github link to a source repo and tap into all that hardwork.

      When you add a new one, it will get stored in your settings file under 'sources'
      )
  end

  def sources_sync
    return if !HeyDan.help?
    puts %Q(
      Sync all the sources in your settings file.
      )
  end

  def sources_update
    return if !HeyDan.help?
    puts %Q(
      Update a single source.
      )
  end

  def sources_build
  end

  def sources_new
  end

  def git_clone(name)
    return if !HeyDan.help?
    puts %Q(Cloning #{name} into #{HeyDan.folders[:sources]})
  end

  def git_update(name)
    return if !HeyDan.help?
    puts %Q(Updating #{name} in #{HeyDan.folders[:sources]})
  end

  def build_identifier(identifier)
    return if !HeyDan.help?
    puts %Q("building identifiers hash for #{identifier} to filenames, this might take a moment")
  end

end

end
class HeyDan::HelpText
  class << self
    def setup(opts={}) 
      %Q(
          Hi! Adding a jurisdictions, datasets, downloads and sources directory and a settings.yml file. If you want to move these directories to other places, just update their locations in the settings file. 

          If you want to run heydan from a different folder than the settings.yml, create an environment variable:

          export HEYDAN_SETTINGS = full/path/to/settings.yml

          To turn off this help, run 'heydan help off' or set the help in settings to false.

          heydan grabs datasets and information about jurisdictions. If you want to focus on just one type of jurisdiction, update the settings 'jurisdiction_type'. Or you can pass --type school_district to any heydan command.

          Next, run `heydan build` to setup your files.
      )
  end

  def build(opts={})
    type = opts[:type] || all
    %Q(
      Woot, building files for type #{type} jurisdictions/. You will see a progress bar below. If you didn't specify a type, it might take a while. 

      heydan uses the Open Civic Identifiers format to structure file names and main identification for jurisdictions. This helps create a unique nonchanging identification code for every jurisdiction, based on the sponsoring parent. So, the State of Kansas, would be country:us/state:kansas. heydan creates a flat json file for each jurisdiction, which you can then import into your own application or elasticsearch.

      Next, run heydan sources sync
      )
  end
end

end
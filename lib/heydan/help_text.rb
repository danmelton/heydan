class HeyDan::HelpText
  class << self
    def setup(opts={}) 
      %Q(
          Hi! Adding a jurisdictions, datasets, downloads and sources directory and a settings.yml file. If you want to move these directories to other places, just update their locations in the settings file. 

          To turn off this help, run 'heydan help off' or set the help in settings to false.

          heydan grabs datasets and information about jurisdictions. If you want to focus on just one type of jurisdiction, update the settings 'jurisdiction_type'. Or you can pass --type school_district to any heydan command.

          Next, run `heydan build` to setup your files.
      )
  end
end

end
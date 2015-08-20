
class HeyDan::OpenCivicIdentifiers 
  include HeyDan

  class << self
    attr_accessor :jurisdiction_type
    attr_accessor :jurisdictions_folder

    def build(opts={})
      @jurisdiction_type = opts[:type]
      HeyDan::Base.load_or_create_settings
      HeyDan::Base.create_folders
      @jurisdictions_folder = HeyDan.folders[:jurisdictions]
      @data = HeyDan::Helper.download
    end

  end
end
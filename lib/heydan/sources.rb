
class HeyDan::Sources
  class << self
    
    def source_exists?(name_or_link)
      HeyDan.sources.keys.map(&:to_s).include?(name_or_link) || HeyDan.sources.values.include?(name_or_link)
    end

    def sync
    end

    def add(link)
      settings_file = HeyDan::Base.load_or_create_settings
      if !source_exists?(link)
        name = extract_name(link)
        HeyDan.sources.merge!({"#{name}" => link})
        HeyDan::Base.save_settings
      end

    end

    def update(name)
    end

    def extract_name(git_link)
      git_link.match(/\/(.+)\.git/i)[1]
    end

  end
end
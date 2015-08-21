require 'ruby-git'

class HeyDan::Sources
  class << self
    
    def source_exists?(name_or_link)
      HeyDan.sources.keys.map(&:to_s).include?(name_or_link) || HeyDan.sources.values.include?(name_or_link)
    end

    def sync
      HeyDan.sources.keys.each { |source| update(source)}
    end

    def add(link)
      settings_file = HeyDan::Base.load_or_create_settings
      name = extract_name(link)
      if !source_exists?(link)
        HeyDan.sources.merge!({"#{name}" => link})
        HeyDan::Base.save_settings
      end
      update(name)
    end

    def update(name)
      if directory_exist?(name)
        HeyDan::HelperText.git_update(name)
        g = Git.open(source_folder(name), :log => Logger.new(STDOUT))
        g.pull
      else
        HeyDan::HelperText.git_clone(name)
        g = Git.clone(HeyDan.sources[name], name, :path => HeyDan.sources)
      end
    end

    def source_folder(name)
      File.join(HeyDan.folders[:source],name)
    end
    
    def directory_exist?(name)
      Dir.exists?(source_folder)
    end    

    def extract_name(git_link)
      git_link.match(/\/(.+)\.git/i)[1]
    end

  end
end
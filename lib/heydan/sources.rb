require 'git'

class HeyDan::Sources
  class << self
    
    def source_exists?(name_or_link)
      HeyDan.sources ||= {} 
      HeyDan.sources.keys.map(&:to_s).include?(name_or_link) || HeyDan.sources.values.include?(name_or_link)
    end

    def sync
      keys = HeyDan.sources.keys
      if keys
        HeyDan.sources.keys.map(&:to_s).each { |source| update(source)}
      end
    end

    def add(link)
      raise 'Link must be a git link in the format of http(s)://url/*.git' if !correct_link?(link)
      settings_file = HeyDan::Base.load_or_create_settings
      name = extract_name(link)
      if !source_exists?(link)
        HeyDan.sources ||= {} 
        HeyDan.sources.merge!({"#{name}" => link})
        HeyDan::Base.save_settings
      end
      update(name)
    end

    def correct_link?(link)
      !link.match(/(http|https):\/\/\w+\.\w+(\/\w+)+\.git/).nil?
    end

    def update(name)
      if directory_exist?(name)
        HeyDan::HelpText.git_update(name)
        g = Git.open(source_folder(name))
        g.pull
      else
        HeyDan::HelpText.git_clone(name)
        g = Git.clone(HeyDan.sources[name.to_sym], name, {:path => HeyDan.folders[:sources]})
      end
    end

    def source_folder(name)
      File.join(HeyDan.folders[:sources],name)
    end
    
    def directory_exist?(name)
      Dir.exists?(source_folder(name))
    end    

    def extract_name(git_link)
      git_link.match(/(\w+)\.git$/i)[1]
    end

    def create_folder(name)
      FileUtils.mkdir_p source_folder(name)
    end

    def create_source(folder, name)
      file = HeyDan::SourceFile.new(folder, name)
      file.save
    end

    def create_variable(folder, name, variable)
      file = HeyDan::SourceFile.new(folder, name)
      file.add_variable(variable)
      file.save
    end

    def source_exist?(folder, name)
      file = HeyDan::SourceFile.new(folder, name)
      file.exist?
    end

    def variable_exist?(folder, source_name, variable)
      file = HeyDan::SourceFile.new(folder, name)
      return file.exist? if !file.exist?
      file.variable(variable).nil?
    end

    def only_letters_and_underscores?(text)
    end

    def create(folder, source_name, variable=nil)
      create_folder(folder) if !directory_exist?(folder)
      create_source(folder, source_name) if !source_exist?(folder, source_name)
      create_variable(folder, source_name, variable) if !variable_exist?(folder, source_name, variable)
    end

    def build(folder, name=nil, variable=nil, options={})
    end

  end
end
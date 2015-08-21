require 'yaml'
class HeyDan::Base

  class << self
    def setup(dir=nil)
      setup_dir(dir) if dir
      dir ||= Dir.pwd
      load_or_create_settings dir
      create_folders
    end

    def create_folders
      HeyDan::folders.keys.each do |folder|
        path = HeyDan::folders[folder]
        FileUtils.mkdir_p path if !Dir.exist?(path)
      end
    end

    def load_or_create_settings(dir=nil)
      dir ||= Dir.pwd
      HeyDan.settings_file ||= if ENV['HEYDAN_SETTINGS']
        ENV['HEYDAN_SETTINGS']
      else
        File.join(dir, 'heydan_settings.yml')
      end
      return load_settings_file(HeyDan.settings_file) if File.exist?(HeyDan.settings_file)
      create_settings_file(dir)
      HeyDan.settings_file
    end

    def load_settings_file(settings_file)
      settings = YAML.load(File.read(settings_file))
      settings.keys.each do |key|
        method = key.to_s + '='
        HeyDan.send(method, settings[key]) if HeyDan.respond_to?(method)
      end
      HeyDan.settings_file = settings_file
    end

    def save_settings(settings_file=nil)
      settings_file ||= HeyDan.settings_file
      File.open(settings_file, 'w') do |f|
        f.write({help: HeyDan.help, 
          folders: HeyDan.folders, 
          sources: HeyDan.sources
        }.to_yaml)
      end
    end

    def create_settings_file(dir)
      setup_dir(dir)
      setup_folders(dir)
      settings_file = File.join(dir, 'heydan_settings.yml')
      save_settings(settings_file)
    end

    def setup_dir(dir)
      if !Dir.exist?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def setup_folders(dir)
      HeyDan::folders.keys.each do |folder| 
        HeyDan::folders[folder] = File.join(dir,HeyDan::folders[folder])
      end
    end

  end

end
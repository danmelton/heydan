require 'yaml'
class HeyDan::Base

  class << self
    def setup(dir=nil)
      setup_dir(dir) if dir
      load_or_create_settings dir
      create_folders
    end

    def create_folders
      HeyDan::folders.keys.each do |folder|
        path = HeyDan::folders[folder]
        FileUtils.mkdir_p path if !Dir.exist?(path)
      end
    end

    def load_or_create_settings(dir)
      settings_file = File.join(dir, 'heydan_settings.yml')
      return load_settings(settings_file) if File.exist?(settings_file)
      create_settings(dir)
    end

    def load_settings_file(dir)
      settings_file = File.join(dir, 'heydan_settings.yml')
      settings = YAML.load(File.read(settings_file))
      settings.keys.each do |key|
        method = key.to_s + '='
        HeyDan.send(method, settings[key]) if HeyDan.respond_to?(method)
      end
    end

    def create_settings_file(dir)
      setup_dir(dir)
      setup_folders(dir)
      settings_file = File.join(dir, 'heydan_settings.yml')
      File.open(settings_file, 'w') do |f|
        f.write({folders: HeyDan::folders}.to_yaml)
      end
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
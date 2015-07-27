class HeyDan::Helpers

  def self.classify(name)
    name.split('_').collect(&:capitalize).join
  end

  def self.download(url, name, ext, path=nil)
    path ||= SETTINGS[:tmp_folder]
    file_name = name.include?(ext) ? name : "#{name}.#{ext}"
    new_file = File.join(path, file_name)
    return new_file if File.exist?(new_file)
    require 'open-uri'
    puts "Downloading #{url}"
    f = open(url)
    File.open(new_file, 'wb') do |saved_file|
      saved_file.write(f.read)
    end 
    new_file
  end


end
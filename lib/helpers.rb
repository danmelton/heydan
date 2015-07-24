require 'pry'

class HeyDan::Helpers

  def self.classify(name)
    name.split('_').collect(&:capitalize).join
  end

  def self.download(url, name, ext)
    new_file = File.join(Dir.pwd, 'tmp', "#{name}.#{ext}")
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
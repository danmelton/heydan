class HeyDan::Helpers

  def self.classify(name)
    name.split('_').collect(&:capitalize).join
  end

  def self.download(url, name, ext, path=nil)
    path ||= SETTINGS[:downloads_folder]
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

  def self.download_zip(url,path=nil)
    path ||= SETTINGS[:downloads_folder]
    file_name = url.split('/')[-1]
    download_path = File.join(path, file_name)
    if !File.exist?(download_path)
      require 'open-uri'
      puts "Downloading #{url}"
      f = open(url)
      File.open(new_file, 'wb') do |saved_file|
        saved_file.write(f.read)
      end 
    end
    require 'zip'
    files = []
    Zip::File.open(download_path) do |zip_file|
      zip_file.each do |entry|
        download_path = File.join(path, entry.name)
        entry.extract(download_path) unless File.exists?(download_path)
        files << download_path
      end
    end
    files
  end


end
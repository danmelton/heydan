class HeyDan::CDN < HeyDan

  #Download files from the CDN
  def download
    identifiers.each do |f|
      file_name = f.gsub('.json', '.csv')
      HeyDan::Helpers::download("#{@settings[:cdn]}/#{file_name}", file_name, 'csv', @settings[:downloads_folder])
    end
    datasets.each do |f|
      file_name = f.gsub('.json', '.csv')
      HeyDan::Helpers::download("#{@settings[:cdn]}/#{file_name}", file_name, 'csv', @settings[:downloads_folder])
    end
  end


  #Upload files from the Downloads folder
  def upload

    require 'fog'
    @connection = Fog::Storage.new({
      provider: 'AWS',
      region: @settings[:aws_region],
      aws_access_key_id: @settings[:aws_access_id],
      aws_secret_access_key: @settings[:aws_secret_key]
    })
    @directory = @connection.directories.get(@settings[:aws_bucket])

    files = Dir.glob("#{@settings[:downloads_folder]}/*.csv")
    files.each do |f|
      name = f.gsub("#{@settings[:downloads_folder]}/", '')
      puts "uploading #{name}"
      file = @directory.files.new({
        :key    => name,
        :body   => File.open(f, 'r'),
        :public => true
      })
      file.save
    end    
  end

end
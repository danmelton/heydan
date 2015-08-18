class HeyDan::CDN < HeyDan

  #Download files from the CDN
  def download
    identifiers.each do |f|
      file_name = f.gsub('.json', '.csv')
      HeyDan::Helpers::download("#{@settings[:cdn]}/#{file_name}", file_name, 'csv', @settings[:datasets_folder])
    end
    datasets.each do |f|
      file_name = f.gsub('.json', '.csv')
      HeyDan::Helpers::download("#{@settings[:cdn]}/#{file_name}", file_name, 'csv', @settings[:datasets_folder])
    end
  end


  #Upload files from the Downloads folder
  def upload(names=[])
    require 'fog'
    @connection = Fog::Storage.new({
      provider: 'AWS',
      region: @settings[:aws_region],
      aws_access_key_id: @settings[:aws_access_id],
      aws_secret_access_key: @settings[:aws_secret_key]
    })
    @directory = @connection.directories.get(@settings[:aws_bucket])
    if names.size == 0
      files = Dir.glob("#{@settings[:datasets_folder]}/*.csv")
    else
      files = names.map { |f| File.join(@settings[:datasets_folder], "#{f}.csv")}
    end
    files.each do |f|
      name = f.gsub("#{@settings[:datasets_folder]}/", '')
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
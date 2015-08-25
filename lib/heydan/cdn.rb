class HeyDan::Cdn

  #Upload files from the Downloads folder
  def upload(names=[])
    require 'fog'
    @connection = Fog::Storage.new({
      provider: 'AWS',
      region: HeyDan.aws_region,
      aws_access_key_id: HeyDan.aws_access_id,
      aws_secret_access_key: HeyDan.aws_secret_key
    })
    @directory = @connection.directories.get(HeyDan.aws_bucket)
    if names.size == 0
      files = Dir.glob("#{HeyDan.folders[:datasets]}/*.csv")
    else
      files = names.map { |f| File.join(HeyDan.folders[:datasets], "#{f}.csv")}
    end
    files.each do |f|
      name = f.gsub("#{HeyDan.folders[:datasets]}/", '')
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
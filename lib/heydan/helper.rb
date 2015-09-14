require 'digest'
require 'uri'
require 'open-uri'
require 'csv'
require 'fileutils'

class HeyDan::Helper

  class << self

    def classify(name)
      name.split('_').collect(&:capitalize).join
    end

    def download(url)
      path = HeyDan.folders[:downloads]
      FileUtils.mkdir_p path if !Dir.exists?(path)
      new_file = File.join(path, md5_name(url))
      return new_file if File.exist?(new_file)
      download_file(url, new_file)
      new_file
    end

    def save_data(name, data)
      full_path = File.expand_path(File.join(HeyDan.folders[:datasets], "#{name.gsub('.csv', '')}.csv"))
      CSV.open(full_path, 'w') do |csv|
        data.each do |row|
          csv << row
        end
      end
    end

    def get_data(name)
      CSV.read(File.join(HeyDan.folders[:datasets], "#{name.gsub('.csv', '')}.csv"))
    end

    def dataset_exists?(name)
      File.exist?(File.join(HeyDan.folders[:datasets], "#{name.gsub('.csv', '')}.csv"))
    end

    def get_data_from_url(url)
      ext = get_file_type_from_url(url)
      file = download(url)
      @data = case ext
        when 'csv'
          get_csv_data(file)
        when 'xls'
          get_excel_data(file)
        when 'xlsx'
          get_excel_data(file, 'xlsx')
        when 'zip'
          files = unzip(file)
          return get_shapefile_data(files) if is_shapefile?(files)
          if files.size == 1
            return get_csv_data(files[0]) if is_csv?(files[0])
            return get_excel_data(files[0]) if is_excel?(files)
          else
            files.map { |f| get_csv_data(f) if is_csv?(f)} 
          end
        when 'txt'
          get_csv_data(file) if is_csv?(file)
        when 'shp'
          get_shapefile_data(file)
        else
          get_csv_data(file) if is_csv?(file)
        end
      @data
    end

    def is_csv?(file_path)
      contents = File.open(file_path, &:readline)
      contents.match(/\b\t/).nil? || contents.match(/\b,/).nil? #not perfect
    end

    def is_shapefile?(shapefile_array)
      !get_shapefile(shapefile_array).nil?
    end

    def get_shapefile(shapefile_array)
      shapefile_array.select { |file| file.to_s.include?('.shp')}[0]
    end

    def get_shapefile_data(shapefile_array)
      file = get_shapefile(shapefile_array)
      require 'geo_ruby'
      require 'geo_ruby/shp'
      
      shp = GeoRuby::Shp4r::ShpFile.open(file)
      data = [shp.fields.map(&:name) + ['geojson']]
      shp.records.each do |record|
        data << (record.data.attributes.values + [record.geometry.as_json])
      end
      data
    end

    def get_excel_file(files)
      files.select { |file| file.to_s.include?('.xls') || file.to_s.include?('.xlsx')}[0]
    end

    def is_excel?(files)
      !get_excel_file(files).nil?
    end

    def get_excel_data(file, type='xls')
      if type == 'xls'
        require 'spreadsheet'
        book = Spreadsheet.open file
        data = book.worksheets.map(&:rows)
      else
        require 'rubyXL'
        book = RubyXL::Parser.parse(file)
        data = book.worksheets.map do |w| 
          w.sheet_data.rows.map { |row|
            row.cells.map { |c| c.value } unless row.nil?
          }
        end
      end
      return data[0] if data.size == 1
      data
    end

    def get_csv_data(file)
      contents = File.read(file, :encoding => 'utf-8').encode("UTF-8", :invalid=>:replace, :replace=>"").gsub('"',"")

      if contents.include?("\t")
        CSV.parse(contents, { :col_sep => "\t" })
      else
        CSV.parse(contents)
      end
      
    end

    def md5_name(text)
      Digest::MD5.hexdigest(text)
    end

    def download_file(url,file_path)
      f = open(url)
      full_path = File.expand_path(file_path)
      File.open(full_path, 'wb') do |saved_file|
        saved_file.write(f.read)
      end 
      full_path
    end

    def get_file_type_from_url(url)
      file_type = File.extname(URI.parse(url).path).gsub('.', '') 
    end

    def unzip(file)
      path = HeyDan.folders[:downloads]
      require 'zip'
      files = []
      Zip::File.open(file) do |zip_file|
        zip_file.each do |entry|
          download_path = File.expand_path(File.join(path, entry.name))
          entry.extract(download_path) unless File.exists?(download_path)
          files << download_path
        end
      end
      files
    end

  end
end
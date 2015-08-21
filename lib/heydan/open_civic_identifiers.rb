
class HeyDan::OpenCivicIdentifiers 
  include HeyDan

  class << self
    attr_accessor :jurisdiction_type
    attr_accessor :jurisdictions_folder
    attr_accessor :data

    def name
      'open_civic_data'
    end

    def build(opts={})
      @jurisdiction_type = opts[:type]
      HeyDan::Base.load_or_create_settings
      HeyDan::Base.create_folders
      @jurisdictions_folder = HeyDan.folders[:jurisdictions]
      download
      build_jurisdiction_files
    end

    def download
      if !HeyDan::Helper.dataset_exists?(name)
        @data = HeyDan::Helper.get_data_from_url('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true')
        @data = @data[1..-1].map { |c| [c[0], c[1]]}
        filter_by_type if @jurisdiction_type
        @data.unshift(['id', 'name'])
        HeyDan::Helper.save_data(name, @data)
      end
    end

    def filter_by_type
      @data = @data.select { |x| x[0].include? @jurisdiction_type}
    end

    def build_jurisdiction_files
      if @data.nil?
        @data = HeyDan::Helper.get_data(name)
      end
      @data[1..-1].each do |row| 
        jf = HeyDan::JurisdictionFile.new(name: row[0])
        next if row[0].nil?
        jf.add_identifier('open_civic_id', row[0])
        jf.add_property('name', row[1])
        jf.save
      end
    end
  end
end
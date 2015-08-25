require 'ruby-progressbar'

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
      @jurisdiction_type = HeyDan.options[:type]
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
        @data.unshift(['id', 'name'])
        HeyDan::Helper.save_data(name, @data)
      end
    end

    def build_jurisdiction_files
      if @data.nil?
        @data = HeyDan::Helper.get_data(name)
      end
      @progress = ProgressBar.create(:title => "Building Files in #{HeyDan.folders[:jurisdictions]} for jurisdictions #{('matching ' + @jurisdiction_type) if @jurisdiction_type}", :starting_at => 0, :total => @data[1..-1].size) if HeyDan.help?
      @data[1..-1].each_index do |i| 
        row = @data[i]
        jf = HeyDan::JurisdictionFile.new(name: row[0])
        next if !jf.match_type?(@jurisdiction_type)
        jf.add_identifier('open_civic_id', row[0].gsub('ocd-division/',''))
        jf.add_property('name', row[1])
        jf.save
        @progress.progress = i  if HeyDan.help?
      end
      @progress.finish if HeyDan.help?
    end
  end

end
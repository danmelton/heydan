class OpenCivicIdentifiers < HeyDan::Identifier
  def get_data
    file = HeyDan::Helpers::download('https://github.com/opencivicdata/ocd-division-ids/blob/master/identifiers/country-us.csv?raw=true', @name, 'csv')
    @csv_final_data = CSV.read(file)
    super
  end

  def type
    'open_civic_id'
  end

  def transform_data
    @csv_final_data = @csv_final_data[1..-1].map { |c| [c[0], c[1]]}
    @csv_final_data = @csv_final_data.unshift(['id', 'name'])
    super
  end

  def skip_file?(jf)
    jf.exists?
  end

  def add_other_data(jurisdiction_file, header, row)
    name = header.index('name')
    jurisdiction_file.add_property('name', row[name])
  end

end

require 'json'

class HeyDan::SourceFile
  attr_accessor :json
  attr_accessor :file_path
  attr_accessor :folder_path
  attr_accessor :folder
  attr_accessor :name

  def initialize(folder, name)
    @folder = folder
    @name = name
    @folder_path = File.join(HeyDan.folders[:sources],@folder)
    @file_path = File.join(@folder_path, @name)
    get_json
  end

  def get_json
    if exist?
      @json = JSON.parse(File.read(file_path))
    else
      @json = initial_json
    end
  end

  def create_folder
    FileUtils.mkdir_p @folder_path if !Dir.exist?(@folder_path)
  end  

  def exist?
    File.exist?(@file_path)
  end

  def add_variable(variable_name)
    @json['variables'][variable_name] = variable_json(variable_name)
  end

  def initial_json
    {'name' => @name, 'short_description' => 'A short description', 'long_description' => 'a longer description', 'notes' => nil, 'depends' => nil, 'sourceUrl' => 'the website of the source', 'variables' => {}}
  end

  def variable_json(variable_name)
    {'name' => variable_name, 'short_description' => 'a short description', 'long_description' => 'a description of the variable', 'notes' => 'any notes about this variable', 'identifier' => 'open_civic_id or ansi_id or other', 'dates' => [2015], 'tags' => [], 'sourceUrl' => 'website for variables information if different than source', 'jurisdiction_types' => [], 'coverage' => {} }
  end

  def variable(variable_name)
    @json['variables'][variable_name]
  end

  def save
    create_folder
    File.open(@file_path, 'w') do |f|
      f.write(@json.to_json)
    end
  end

end
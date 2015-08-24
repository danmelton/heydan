require 'json'

class HeyDan::SourceFile
  attr_accessor :json
  attr_accessor :file_path
  attr_accessor :folder_path
  attr_accessor :folder
  attr_accessor :name
  attr_accessor :variable

  def initialize(folder, name, variable=nil)
    @folder = folder
    @name = name
    @variable = variable
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
    @json['variables'][variable_name] = variable_json(variable_name) if variable(variable_name).nil?
    variable(variable_name)
  end

  def create_variable_scripts
    if @json['variables'].keys.size > 0
      @json['variables'].keys.each do |variable|
        create_script_file(variable)
      end
    end
  end

  def create_script_file(variable_name)
    file = HeyDan::ScriptFile.new(@folder, @name, variable_name)
    file.save
  end

  def initial_json
    {'name' => @name, 'short_description' => 'A short description', 'long_description' => 'a longer description', 'notes' => nil, 'depends' => nil, 'sourceUrl' => 'the website of the source', 'variables' => {}}
  end

  def variable_json(variable_name)
    {'id' => "#{@folder}_#{@name}_#{variable_name}",'name' => variable_name, 'short_description' => 'a short description', 'long_description' => 'a description of the variable', 'notes' => 'any notes about this variable', 'identifier' => 'open_civic_id or ansi_id or other', 'dates' => [2015], 'tags' => [], 'sourceUrl' => 'website for variables information if different than source', 'jurisdiction_types' => [], 'coverage' => {} }
  end

  def variable(variable_name=nil)
    variable_name ||= @variable 
    @json['variables'][variable_name]
  end

  def variables
    @json['variables'].keys
  end

  def save
    create_folder
    create_variable_scripts
    File.open(@file_path, 'w') do |f|
      f.write(JSON.pretty_generate(@json))
    end
  end

end
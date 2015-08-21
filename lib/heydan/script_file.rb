class HeyDan::ScriptFile
  attr_accessor :folder
  attr_accessor :source
  attr_accessor :variable
  attr_accessor :script_folder_path
  attr_accessor :script_file_path
  attr_accessor :module_name
  attr_accessor :name


  def initialize(folder, source, variable)
    @folder, @source, @variable = folder, source, variable
    @name = @folder + "_" + @source + "_" + @variable
    create_module_name
    @script_folder_path = File.join(HeyDan.folders[:sources], @folder, 'scripts')
    @script_file_path = File.join(@script_folder_path, "#{@name}.rb")
  end

  def create_script_folder
    FileUtils.mkdir_p @script_folder_path if !Dir.exist?(@script_folder_path)
  end

  def create_module_name
    @module_name = @name.split('_').collect(&:capitalize).join
  end

  def template
    %Q(class #{@module_name} < HeyDan::Helper\nend)
  end

  def save
    create_script_folder
    File.open(@script_file_path, 'w') do |f|
      f.write(template)
    end
  end
end
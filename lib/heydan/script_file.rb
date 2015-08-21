class HeyDan::ScriptFile
  attr_accessor :folder
  attr_accessor :source
  attr_accessor :variable
  attr_accessor :script_folder_path
  attr_accessor :script_file_path
  attr_accessor :class_name
  attr_accessor :name


  def initialize(folder, source, variable)
    @folder, @source, @variable = folder, source, variable
    @name = @folder + "_" + @source + "_" + @variable
    create_class_name
    @script_folder_path = File.join(HeyDan.folders[:sources], @folder, 'scripts')
    @script_file_path = File.join(@script_folder_path, "#{@name}.rb")
  end

  def create_script_folder
    FileUtils.mkdir_p @script_folder_path if !Dir.exist?(@script_folder_path)
  end

  def create_class_name
    @class_name = @name.split('_').collect(&:capitalize).join
  end

  def template
    %Q(class #{@class_name} < HeyDan::Helper\nend)
  end

  def save
    create_script_folder
    File.open(@script_file_path, 'w') do |f|
      f.write(template)
    end
  end

  def eval_class
    load script_file_path
    return eval("#{@class_name}.new")
  end
end
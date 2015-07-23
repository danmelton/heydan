class HeyDan::Dataset < HeyDan
  attr_accessor :name
  
  def initialize(opts={})
    @name = opts[:name].downcase
    super(opts)
  end

  def create
    require 'erb'
    return puts "Not a valid name, only '_' are allowed" if !valid_name?
    return puts "Files already exist with the name '#{@name}'" if file_exist?
    create_ruby_file
    create_json_file
  end

  def create_ruby_file
    ruby_template = File.read(File.join(Dir.pwd, 'scripts', 'template.rb.erb'))
    @class_name = @name.split('_').collect(&:capitalize).join
    new_file =  ERB.new(ruby_template).result binding
    File.open(File.join(@settings[:scripts_folder], "#{@name}.rb"), 'w') do |f|
      f << new_file
    end
  end

  def create_json_file
    json_template = File.read(File.join(Dir.pwd, 'datasets', 'template.json.erb'))
    new_file =  ERB.new(json_template).result binding
    File.open(File.join(@settings[:datasets_folder], "#{@name}.json"), 'w') do |f|
      f << new_file
    end
  end

  def valid_json?
    require ''
    begin
      json = File.read(File.join(@settings[:datasets_folder], "#{@name}.json"))
      JSON.parse(json)  
    return true  
    rescue JSON::ParserError  
      return false  
    end  
  end


  def valid_name?
    (@name =~ /\s|\-|\!|\.|\^|\*|~/).nil?
  end

  def file_exist?
    File.exists?(File.join(@settings[:scripts_folder], "#{@name}.rb")) || File.exists?(File.join(@settings[:datasets_folder], "#{@name}.json"))
  end
end
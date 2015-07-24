require File.join(Dir.pwd, 'lib', 'hey_dan')

class SampleIdentifier < HeyDan::Identifier
  def get_data
    @csv_final_data = [['love'],[1]]
  #this method is used to connect to a source, like an api, ftp or download a csv, and then saves it into the tmp folder.
    super
  end

  def transform_data
  #this method can transform data, like, pulling in data from another file and computing new data like trends, sums, etc. 
  #note, you don't need to do anything here if you don't want to process any data
    super
  end

  def save_data
  #this method savxqes the file into downloads
    super
  end

end
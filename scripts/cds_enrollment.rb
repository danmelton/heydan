require File.join(Dir.pwd, 'lib', 'hey_dan')

class CdsEnrollment < HeyDan::Script
  def get_data
    @csv_final_data = {}
    ["2014-15","2013-14","2012-13","2011-12","2010-11","2009-10","2008-09","2007-08","0607","0506","0405","0304","0203","0102","0001","9900","9899","9798","9697","9596","9495","9394"].each do |year|
    url = "http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=#{year}&cCat=Enrollment&cPage=filesenr.asp"
    file = HeyDan::Helpers::download(url, @name+"_#{year}", 'csv')
    contents = File.read(file, :encoding => 'utf-8').encode("UTF-8", :invalid=>:replace, :replace=>"").gsub('"',"")
    csv = CSV.parse(contents, { :col_sep => "\t" })

    @csv_final_data[year] = csv[1..-1].map { |x| [x[0], x[-2]]}
    end
    super
  end

  def transform_data

    #loop through each row
    #create the school district code off of the first seven diggts (which includes zeros)
    #add to that value or if nil set it to the value
    
    districts = {}
    @csv_final_data.keys.each do |year_key|

      @csv_final_data[year_key][1..-1].each do |row|
        key = row[0][0..6]+'0000000'
        row[1]=row[1].to_i
          if districts[key].nil?
            districts[key]=Array.new(@csv_final_data.keys.size, 0)
            districts[key][@csv_final_data.keys.index(year_key)]=row[1]
          
          else
            districts[key][@csv_final_data.keys.index(year_key)]=districts[key][@csv_final_data.keys.index(year_key)]+row[1]        
          end

      end

    end
    data = []
    districts.keys.each do |key|
      data << [key] + districts[key]
    end 
    @csv_final_data = data.unshift(['cds_code_id', 2014, 2013, 2012, 2011, 2010, 2009, 2008, 2007, 2006, 2005, 2004, 2003, 2002, 2001, 2000, 1999, 1998, 1997, 1996, 1995, 1994, 1993])  
    super
  end

end

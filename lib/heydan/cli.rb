require 'thor'

class HeyDan::Cli < Thor
  class_option 'type'

  desc "setup DIR", "Setups HeyDan in the current directory or specified dirå "
  def setup(dir=nil)
    HeyDan::helper_text('setup')
    HeyDan::Base.setup(dir)
  end
end
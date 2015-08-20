require 'thor'

class HeyDan::Cli < Thor
  class_option 'type'

  desc "setup DIR", "Setups HeyDan in the current directory or specified DIR"
  def setup(dir=nil)
    HeyDan::helper_text('setup')
    HeyDan::Base.setup(dir)
  end

  desc "build", "Builds jurisdiction files"
  def build(dir=nil)
    HeyDan::helper_text('build')
    HeyDan::Base.build
  end
end
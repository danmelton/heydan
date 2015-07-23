class HeyDan::Helpers

  def self.classify(name)
    name.split('_').collect(&:capitalize).join
  end

end
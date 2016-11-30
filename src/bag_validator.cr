class BagValidator
  getter :path_to_bag

  def initialize(path_to_bag : String)
    @path_to_bag = File.expand_path path_to_bag
  end

  def valid?
    true
  end
  
end

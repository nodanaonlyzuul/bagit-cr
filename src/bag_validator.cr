class BagValidator
  getter :path_to_bag

  def initialize(path_to_bag : String)
    @path_to_bag = path_to_bag
  end
  
end

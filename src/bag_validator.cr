class BagValidator
  getter :path_to_bag, :errors

  def initialize(path_to_bag : String)
    @errors      = [] of String
    @path_to_bag = File.expand_path path_to_bag
  end

  def valid?
    @errors.empty?
  end

  def validate!

  end
end

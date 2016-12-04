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
    @errors = [] of String
    validate_manifest_algorithm
    self
  end


  private def validate_manifest_algorithm
    files = Dir.entries(@path_to_bag).map &.downcase
    manifest_name = files.find {|entry| entry.includes?("manifest-")}
    if manifest_name && !["md5", "sha1", "sha256", "sha512"].includes?(manifest_name.split("-")[1])
      @errors << "unknown algorithm used for manifest: #{manifest_name}" 
    end
  end

end

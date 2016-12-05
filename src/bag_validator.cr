class BagValidator
  getter :path_to_bag, :errors, :files_in_manifest

  def initialize(path_to_bag : String)
    @errors         = [] of String
    @path_to_bag    = File.expand_path path_to_bag
    @files_in_manifest = [] of String
    @files_in_manifest = read_manifest.values
  end

  def payload_files
    all_files = Dir[File.join(File.join(@path_to_bag, "data"), "**", "*")].select { |f| File.file? f }
    all_files
  end

  def validate!
    validate_manifest_algorithm
    validate_manifest_contents
    self
  end

  def valid?
    @errors.empty?
  end

  private def validate_manifest_contents
    plfs = payload_files.map {|plf| plf.split(@path_to_bag + "/")[1]}


    @files_in_manifest.each do |file_in_manifest|
      if !plfs.includes?(file_in_manifest)
        @errors << "manifest lists file not contained in bag: #{File.basename(file_in_manifest)}"
      end
    end

    plfs.each do |plf|
      if !@files_in_manifest.includes?(plf)
        @errors << "contains files that are not listed in manifest: #{File.basename(plf)}"
      end
    end

  end

  private def validate_manifest_algorithm
    files = Dir.entries(@path_to_bag).map &.downcase
    manifest_name = files.find {|entry| entry.includes?("manifest-")}
    if manifest_name && !["md5", "sha1", "sha256", "sha512"].includes?(File.basename(manifest_name.split("-")[1], ".txt"))
      @errors << "unknown algorithm used for manifest: #{manifest_name}"
    end
  end

  # TODO: memoize this
  private def read_manifest : Hash
    results = {} of String => String

    files = Dir.entries(@path_to_bag)
    manifest_name = files.find {|entry| entry.includes?("manifest-")}

    File.each_line(File.join(@path_to_bag, manifest_name.to_s)) do |manifest_line|
      hash, filename = manifest_line.split(/\s+/)
      results[hash] = filename
    end

    results
  end
end

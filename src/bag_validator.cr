require "crypto/md5"

class BagValidator
  getter :path_to_bag, :errors, :files_in_manifest

  @manifest_name : String?
  @manifest_type : String?

  VALID_ALGORITHIMS = [/md5/i, /sha1/i, /sha256/i, /sha512/i]

  def initialize(path_to_bag : String)
    @errors            = [] of String
    @files_in_manifest = [] of String

    @path_to_bag       = File.expand_path path_to_bag
    @manifest_name     = manifest_name
    @manifest_type     = manifest_type
    @files_in_manifest = read_manifest.values
  end

  def payload_files
    all_files = Dir[File.join(File.join(@path_to_bag, "data"), "**", "*")].select { |f| File.file? f }
    all_files
  end

  def validate!
    validate_manifest_algorithm
    validate_manifest_contents
    validate_checksums
    self
  end

  def valid?
    @errors.empty?
  end

  private def validate_checksums
    read_manifest.each do |checksum, file_path|
      full_path = File.join(@path_to_bag, file_path)

      # Bad manifests can list files that don't exist
      if File.file?(full_path)
        computed_checksum = Crypto::MD5.hex_digest(File.read(full_path))
        if computed_checksum != checksum
          @errors << "malformed checksum for: #{File.basename(file_path)}"
        end
      end

    end
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

  private def manifest_name : String?
    files = Dir.entries(@path_to_bag).map &.downcase
    files.find {|entry| entry.includes?("manifest-")}
  end

  private def manifest_type : String?
    manifest_name = @manifest_name
    if manifest_name
      name_parts = manifest_name.split("manifest-")
      File.basename(name_parts[1], ".txt")
    end
  end

  private def validate_manifest_algorithm
    mt = @manifest_type
    if mt && VALID_ALGORITHIMS.none?{ |algo_regex| algo_regex.match(@manifest_type.to_s) }
      @errors << "unknown algorithm used for manifest: #{@manifest_name}"
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

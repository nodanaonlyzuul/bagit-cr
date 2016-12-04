# coding: utf-8
require "./spec_helper"

def good_bags
  bag_validator_good_md5    = BagValidator.new(path_to_bag: File.join(".", "resources", "good-md5"))
  bag_validator_good_sha1   = BagValidator.new(path_to_bag: File.join(".", "resources", "good-sha1"))
  bag_validator_good_sha256 = BagValidator.new(path_to_bag: File.join(".", "resources", "good-sha256"))
  bag_validator_good_sha512 = BagValidator.new(path_to_bag: File.join(".", "resources", "good-sha512"))
  {
    bag_validator_good_md5:    bag_validator_good_md5,
    bag_validator_good_sha1:   bag_validator_good_sha1,
    bag_validator_good_sha256: bag_validator_good_sha256,
    bag_validator_good_sha512: bag_validator_good_sha512
  }
end

def bad_bags
  unlisted_file     = BagValidator.new(path_to_bag: File.join(".", "resources", "unlisted-file"))
  unknown_algorithm = BagValidator.new(path_to_bag: File.join(".", "resources", "unknown-algorithm"))
  {
    unlisted_file: unlisted_file,
    unknown_algorithm: unknown_algorithm
  }
end

describe BagValidator do

# Spec.before_each do
# end
#
# Spec.after_each do
# end

it "should validate with no errors" do
  good_bags.values.each do |bag_validator|
    bag_validator.validate!
    bag_validator.valid?.should eq(true)
  end
end

it "should be invalid if there is a file that's in the bag, but not in the manifest" do
  unlisted_bag = bad_bags[:unlisted_file]
  unlisted_bag.validate!
  unlisted_bag.valid?.should eq(false)
  unlisted_bag.errors.includes?("contains files that are not listed in manifest").should eq(true)
end

pending "should be invalid if there are files that are in the manifest but not in the bag" do
#   # add a file and then remove it through the back door
#   @bag.add_file("file-k") { |io| io.puts "time to go" }
#   @bag.manifest!
#
#   FileUtils::rm File.join(@bag.bag_dir, "data", "file-k")
#
#   @bag.validate_only("true_for/completeness")
#   expect(@bag.errors.on(:completeness)).not_to be_empty
#   expect(@bag).not_to be_valid
end

pending "should be invalid if there is a fixity problem" do
  # tweak a file through the back door
#   File.open(@bag.bag_files[0], 'a') { |io| io.puts "oops!" }
#
#   @bag.validate_only("true_for/consistency")
#   expect(@bag.errors.on(:consistency)).not_to be_empty
#   expect(@bag).not_to be_valid
end

pending "should calculate sha1 correctly for a big file" do
#   @bag.add_file 'big-data-file' do |fh|
#     count = 0
#     while count < 1024 * 512 do
#       fh.write "1" * 1024
#       count += 1
#     end
#   end
#   @bag.manifest!
#   sha1_manifest = File.join @bag_path, 'manifest-sha1.txt'
#   checksums = {}
#   File.open(sha1_manifest).each_line do |line|
#       fixity, path = line.split(' ')
#       checksums[path] = fixity
#   end
#   expected = checksums['data/big-data-file']
#   expect(expected).to eq('12be64c30968bb90136ee695dc58f4b2276968c6')
end

pending "should validate by oxum when needed" do
  # expect(@bag.valid_oxum?).to eq(true)
end

it "should raise an sensible error when the manifest algorithm is unknown" do
  unknown_algorithm = bad_bags[:unknown_algorithm]
  unknown_algorithm.validate!
  unknown_algorithm.valid?.should eq(false)
  unknown_algorithm.errors.includes?("unknown algorithm used for manifest: dankmeme").should eq(true)
end

pending "should validate false by oxum when file count is incorrect" do
#   # tweak oxum through backdoor
#   File.open(@bag.bag_info_txt_file, 'a') { |f| f.write "Payload-Oxum: " + @bag.bag_info["Payload-Oxum"].split('.')[0] + '.0' }
#   expect(@bag.valid_oxum?).to eq(false)
end

pending "should validate false by oxum when octetstream size is incorrect" do
#   # tweak oxum through backdoor
#   File.open(@bag.bag_info_txt_file, 'a') { |f| f.write "Payload-Oxum: 1." + @bag.bag_info["Payload-Oxum"].split('.')[1] }
#   expect(@bag.valid_oxum?).to eq(false)
end

 describe "tag manifest validation" do
  pending "should be invalid if there are no manifest files at all even when there are no files" do
  #   #remove all files, tag/manifest files & tagmanifest files through the back door
  #   @bag.bag_files.each do |bag_file|
  #     FileUtils::rm bag_file
  #   end
  #   @bag.tag_files.each do |tag_file|
  #     FileUtils::rm tag_file
  #   end
  #   @bag.tagmanifest_files.each do |tagmanifest_file|
  #     FileUtils::rm tagmanifest_file
  #   end
  #
  #   # @bag.should_not be_valid
  #   expect(@bag).not_to be_valid
  #   expect(@bag.errors.on(:completeness)).not_to be_empty
  end
 end

describe "tag manifest validation" do
  pending "should be invalid if listed tag file does not exist" do
  #   # add a file and then remove it through the back door
  #   @bag.add_tag_file("tag-k") { |io| io.puts 'time to go' }
  #   @bag.tagmanifest!
  #
  #   FileUtils::rm File.join(@bag.bag_dir, 'tag-k')
  #
  #   # @bag.should_not be_valid
  #   expect(@bag).not_to be_valid
  #   expect(@bag.errors.on(:completeness)).not_to be_empty
  end
end
end

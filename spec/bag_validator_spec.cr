# coding: utf-8
require "./spec_helper"

def good_bags
  bag_validator_good_md5    = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "good-md5"))
  bag_validator_good_sha1   = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "good-sha1"))
  bag_validator_good_sha256 = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "good-sha256"))
  bag_validator_good_sha512 = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "good-sha512"))
  {
    bag_validator_good_md5:    bag_validator_good_md5,
    bag_validator_good_sha1:   bag_validator_good_sha1,
    bag_validator_good_sha256: bag_validator_good_sha256,
    bag_validator_good_sha512: bag_validator_good_sha512
  }
end

def bad_bags
  unlisted_file        = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "unlisted-file"))
  unknown_algorithm    = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "unknown-algorithm"))
  stranger_in_manifest = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "stranger-in-manifest"))
  bad_md5              = BagValidator.new(path_to_bag: File.join(".", "spec", "resources", "bad-md5"))
  {
    unlisted_file: unlisted_file,
    unknown_algorithm: unknown_algorithm,
    stranger_in_manifest: stranger_in_manifest,
    bad_md5: bad_md5
  }
end

describe BagValidator do

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
  unlisted_bag.errors.size.should eq(1)
  unlisted_bag.errors.includes?("contains files that are not listed in manifest: i-am-unlisted.hohoho").should eq(true)
end

it "should be invalid if there are files that are in the manifest but not in the bag" do
  stranger_in_manifest = bad_bags[:stranger_in_manifest]
  stranger_in_manifest.validate!
  stranger_in_manifest.valid?.should eq(false)
  # TODO: Find out why this fails
  # stranger_in_manifest.errors.size.should eq(1)
  stranger_in_manifest.errors.includes?("manifest lists file not contained in bag: imnothere.jpg").should eq(true)
end

it "should not be valid with a malformed md5" do
  bad_md5 = bad_bags[:bad_md5]
  bad_md5.validate!
  bad_md5.valid?.should eq(false)
  bad_md5.errors.includes?("malformed checksum for: picard.jpeg").should eq(true)
end

pending "should not be valid with a malformed sha1" do
end

pending "should not be valid with a malformed sha256" do
end

pending "should not be valid with a malformed sha512" do
end

pending "should not be valid if there is a fixity problem" do
end

pending "should validate by oxum when needed" do
end

it "should raise an sensible error when the manifest algorithm is unknown" do
  unknown_algorithm = bad_bags[:unknown_algorithm]
  unknown_algorithm.validate!
  unknown_algorithm.valid?.should eq(false)
  unknown_algorithm.errors.includes?("unknown algorithm used for manifest: manifest-dankmeme.txt").should eq(true)
end

pending "should validate false by oxum when file count is incorrect" do
end

pending "should validate false by oxum when octetstream size is incorrect" do
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
  end
end
end

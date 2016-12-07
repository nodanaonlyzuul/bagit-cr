require "./bag_validator"

bag_validator = BagValidator.new(ARGV[0])
bag_validator.validate!

if bag_validator.valid?
  puts "This bag is valid"
else
  puts "This bag is not valid:" +  bag_validator.errors.join(", ")
end
# require "option_parser"
#
# upcase = false
# destination = "World"
#
# parser = OptionParser.parse! do |parser|
#   parser.banner = "Usage: salute [arguments]"
#   parser.on("-u", "--upcase", "Upcases the salute") do
#     upcase = true
#   end
#
#   parser.on("-t NAME", "--to=NAME", "Specifies the name to salute") do |name|
#     destination = name
#   end
#
#   parser.on("-h", "--help", "Show this help")  do
#     puts parser
#   end
# end
# puts parser if ARGV.size == 0
# destination = destination.upcase if upcase
# puts "Hello #{destination}!"

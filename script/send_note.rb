#
# Send an arbitrary command as defined from the command line to pure data
#
# E.G. ruby scripts/send_command.pd volume 100
#
require "#{File.dirname(__FILE__)}/../lib/pure_data.rb"
pd = PureData.new

index = ARGV[0]
note = ARGV[1]
length = ARGV[2]

puts "Sending note \"#{note}\" \"#{length}\""

pd.send_note(index,note,length.to_i)

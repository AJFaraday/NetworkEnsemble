#
# Send an arbitrary command as defined from the command line to pure data
#
# E.G. ruby scripts/send_command.pd volume 100
#
require "./lib/pure_data.rb"
pd = PureData.new

index = ARGV[0]
event = ARGV[1]

puts "Sending \"#{event}\""

pd.send_command(index, event)

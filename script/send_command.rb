#
# Send an arbitrary command as defined from the command line to pure data
#
# E.G. ruby scripts/send_command.pd volume 100
#
require "#{File.dirname(__FILE__)}/../lib/pure_data.rb"
pd = PureData.new

index = ARGV[0]
command = ARGV[1..-1].join(' ')
puts "Sending \"#{command}\""

pd.send_command(index,command)

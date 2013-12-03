#
# A straight forward metronome to all chanels to test network latency
#
require "./lib/pure_data.rb"
pd = PureData.new

loop do
  pd.send_command(0, 'beep')
  pd.send_command(1, 'beep')
  pd.send_command(2, 'snare')
  pd.send_command(3, 'snare')
  sleep 1
end

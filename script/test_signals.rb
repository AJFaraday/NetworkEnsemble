require './lib/player.rb' 

# straight forward note sequence
p = Player.new('sequences/test/notes.csv')
p.play
p.close

# volume per chanel
p = Player.new('sequences/test/volume.csv')
p.play
p.close

# master volume (across all channels) 
p = Player.new('sequences/test/master_volume.csv')
p.play
p.close

# volume envelopes (ADSR)
p = Player.new('sequences/test/envelopes.csv')
p.play
p.close

# drum line, testing event columns
p = Player.new('sequences/test/drums.csv')
p.play
p.close


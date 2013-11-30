require './lib/player.rb' 

Player.play('sequences/test/notes.csv') # straight forward note sequence
Player.play('sequences/test/chords.csv') # some simultaneous notes
Player.play('sequences/test/volume.csv')# volume per chanel
Player.play('sequences/test/master_volume.csv') # master volume (across all channels) 
Player.play('sequences/test/envelopes.csv') # volume envelopes (ADSR)
Player.play('sequences/test/drums.csv') # drum line, testing event columns
Player.play('sequences/test/synths.csv') # try out multiple synth voices
Player.play('sequences/test/fm.csv') # A quick look at the FM capabilities

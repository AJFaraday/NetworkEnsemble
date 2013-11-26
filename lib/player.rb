#
# November 2013 - Andrew Faraday
#
# The player class handles CSV parsing, message timing/metronome and passing messengers to the Pd in the PureData class
#

class Player

  # The name of the source file
  attr_accessor :file
  # parsed CSV data from file
  attr_accessor :sequence
  # an array of mappings for each row of the CSV file
  attr_accessor :mappings
  # the top half of the time signature
  # the number you'd count to before returning to one
  attr_accessor :pulse_count
  # the bottom half of the time signature
  # the note value represented by the pulse
  attr_accessor :pulse_resolution
  # The note value of each row in the CSV file
  attr_accessor :resolution 
  # the amount of time in milliseconds each row of the CSV file takes
  attr_accessor :step_time
 


  def initialize(file_path)
    


  end

end

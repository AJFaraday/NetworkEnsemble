#
# November 2013 - Andrew Faraday
#
# Converts a note name to a midi number
#
# A note name
# This ranges from C to B
# can be # or b
# then an octave number from 0 to 9 
#
# e.g.
#
# * 'C4' => 60
# * 'C5' => 72
# * 'C3' => 48
# * 'C#4' => 61
# * 'Cb4' => 59
# * 'Db4' => 61
#
class Note
 
  NOTE_NAMES = {
    'C' => 0,
    'D' => 2,
    'E' => 4,
    'F' => 5,
    'G' => 7,
    'A' => 9,
    'B' => 11
  }
  OCTAVES = ['0','1','2','3','4','5','6','7','8','9']

  def Note.get_midi_number(note_name)
    parts = note_name.chars.to_a
    if note_name.length > 3
      puts "#{note_name} is not a valid note, too long."
    elsif note_name.length < 2
      puts "#{note_name} is not a valid note, too short (at least a note name and octave number)"
    elsif !NOTE_NAMES.keys.include?(parts[0].upcase)
      puts "#{note_name} is not a valid note, the first character must be a valid note name (in #{NOTE_NAMES.inspect})"
    elsif !OCTAVES.include?(parts[-1])
      puts "#{note_name} is not a valid note, the last character must be a valid octave number (in #{OCTAVES.inspect})"
    else
      # note name
      n = NOTE_NAMES[parts[0].upcase]
      # accidental (# or b)
      if ['#','b'].include?(parts[1])
        n += parts.delete_at(1) == '#' ? 1 : -1
      end
      # octave
      n += ((12 * parts[-1].to_i) + 12)
      # return note
      return n
    end
    return 0
  end

end

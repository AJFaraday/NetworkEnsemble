#
# November 2013 - Andrew Faraday
#
# The player class handles CSV parsing, message timing/metronome and passing messengers to the Pd in the PureData class
#
require 'csv'
require './lib/pure_data'

class Player

  # The name of the source file
  attr_accessor :file
  # parsed CSV data from file
  attr_accessor :sequence
  # number of parts in the sequence (usually 4)
  attr_accessor :no_parts
  # Pure Data connection instance
  attr_accessor :pure_data
  # mappings for each row of the CSV file
  attr_accessor :master_column # e.g. [5]
  attr_accessor :note_columns # e.g. [1,2,3,4]
  attr_accessor :command_columns # e.g. [6,7,8,9]
  attr_accessor :event_columns # e.g. [10,11,12,13]
  # the top half of the time signature
  # the number you'd count to before returning to one
  attr_accessor :pulse_count
  # the bottom half of the time signature
  # the note value represented by the pulse
  attr_accessor :pulse_resolution
  # The note value of each row in the CSV file
  attr_accessor :resolution 
  # beats per minute
  attr_accessor :bpm
  # the amount of time in milliseconds each row of the CSV file takes
  attr_accessor :step_time
  # next row to play 
  attr_accessor :next_row

  # When it's finished with, tcp sockets are closed, this is flagged
  attr_accessor :closed

  # a list of presets from config/presets.yml
  attr_accessor :presets

  MASTER_COMMANDS = ['bpm', 'time','resolution','master_volume']

  MINUTE_MILLISECONDS = 60000

  #
  # Initial file reading and setting of values.
  #
  def initialize(file_path) 
    self.file = file_path
    self.sequence = CSV.read("#{File.dirname(__FILE__)}/../#{file_path}")
    mapping_row = sequence.shift
    if mapping_row[0].to_i > 0
      self.no_parts = mapping_row[0].to_i
    else 
      raise RuntimeError, "The first cell of the CSV file must be the number of parts. (#{file_path})"
    end
    self.presets = YAML.load_file("#{File.dirname(__FILE__)}/../config/presets.yml")
    generate_mappings
    self.pure_data = PureData.new
    self.next_row = 0
    master_commands(self.sequence[0][master_column])
  end

  def Player.play(file_path,first_index=0)
    p = Player.new(file_path)
    p.play(first_index)
    p.close
  end

  def close
    self.pure_data.connections.each{|x|x.close}
    self.sequence = nil
    self.closed = true
  end
  #
  # generates an array of column mappings as described in CSV_REFERENCE.md
  #   
  def generate_mappings
    self.note_columns = (1..self.no_parts).to_a
    self.master_column = self.note_columns.max + 1
    self.command_columns = ((self.master_column + 1)...(self.master_column + 1 + self.no_parts)).to_a
    self.event_columns = ((self.command_columns.max + 1)...(self.command_columns.max + 1 + self.no_parts)).to_a
  end

  #
  # play the sequence from a given row index.
  #
  def play(first_index=0)
    self.pure_data.send_loadbang # reset to defaults
    # adjust for header and 0 index
    #first_index -= 2
    if self.closed 
      puts "Player has been closed and will not now play."
    else
      self.sequence[first_index..-1].each_with_index do |row, index|
        puts "#{index + first_index + 2}: #{row.compact.join(' , ')}"
        play_row(index + first_index)
      end
      return nil
    end
  end

  #
  # Play single row of sequence
  # 
  def play_row(index)
    row = self.sequence[index]
    master_commands(row[master_column])
    command_columns.each_with_index do |column, index|
      commands = row[column]
      send_commands(index,commands)
    end
    event_columns.each_with_index do |column, index|
      events = row[column]
      send_commands(index,events)
    end
    note_columns.each_with_index do |column,index|
      note = row[column]
      play_note(index, note)
    end
    sleep step_time / 1000.0
  end

  #
  # process commands to the sequencer via the master column
  #
  def master_commands(commands)
    if commands and !commands.empty?
      commands = commands.split(';')
      commands.each do |command|
        command, value = command.split(' ')
        command = command.downcase
        if command and value and MASTER_COMMANDS.include?(command)
          case command.downcase
            when 'master_volume'
              no_parts.times{|i|send_commands(i, "volume #{value}")}
            when 'time'
              self.pulse_count, self.pulse_resolution = value.split('/')
            when 'bpm'
              self.bpm = value
            when 'resolution'
              self.resolution = value
          end
        else 
          raise RuntimeError, "master commands must contain both a valid name (#{MASTER_COMMANDS.inspect}) and a value"
        end   
      end
      set_step_time
    end
  end

  #
  # parse synthesizer commands and send them to Pure Data
  #
  # used for both command and event columns
  #
  def send_commands(index,commands)
    if commands and !commands.empty?
      commands = commands.split(';')
      commands.each do |command| 
        command_parts = command.split(' ')
        if command_parts[0] == 'snare_roll'
          # snare rolls are a special case
          command = "attribute snare_roll #{self.step_time / command_parts[1].to_i} #{self.step_time};"
          puts command
          pure_data.connections[index].send "#{command}\n", 0
        elsif self.presets.keys.include?(command_parts[0].downcase)
          self.presets[command_parts[0].downcase].each{|x|pure_data.send_command(index, x)}
        else 
          pure_data.send_command(index, command.downcase) 
        end
      end
    end
  end

  #
  # parse a note string, and send it to pd
  #
  def play_note(index, note)
    if note
      note, length = note.split(' ')
      length = length.to_i * step_time 
      pure_data.send_note(index,note,length)
    end
  end
 
 
  #
  # whenever time attributes (time signature, bpm or resolution_) change, work out step time again
  #
  def set_step_time
    unless self.pulse_count and self.pulse_resolution and self.bpm and self.resolution
      throw Error, "To set step time there must be a time signature, bpm and note resolution."
    end
    if self.compound_time?
      puts "compound time"
      beat_milliseconds = MINUTE_MILLISECONDS / bpm.to_f
      rows_per_beat = self.resolution.to_f / self.pulse_resolution.to_f
      self.step_time = (beat_milliseconds.to_f / (rows_per_beat * 3)) 
    else # simple time
      puts 'simple time'
      beat_milliseconds = MINUTE_MILLISECONDS / bpm.to_f 
      rows_per_beat = self.resolution.to_f / self.pulse_resolution.to_f
      self.step_time = beat_milliseconds.to_f / rows_per_beat 
    end
    puts "step time = #{self.step_time}"
    #self.step_time = self.step_time / 1000
  end  

  #
  # is it a compound time signature?
  # 
  def compound_time?
    (self.pulse_count.to_i / 3 == self.pulse_count.to_f / 3.0) and self.pulse_count.to_i != 3
  end

end

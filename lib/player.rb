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

  MASTER_COMMANDS = ['bpm', 'time','resolution']

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
      throw Error, "The first cell of the CSV file must be the number of parts."
    end
    generate_mappings
    self.pure_data = PureData.new
    self.next_row = 0
    master_commands(self.sequence[0][master_column])
  end

  #
  # generates an array of column mappings as described in CSV_REFERENCE.md
  #   
  def generate_mappings
    self.note_columns = (1..self.no_parts).to_a
    self.master_column = self.note_columns.max + 1
    self.command_columns = ((self.master_column + 1)..(self.master_column + 1 + self.no_parts)).to_a
    self.event_columns = ((self.command_columns.max + 1)..(self.command_columns.max + 1 + self.no_parts)).to_a
  end

  #
  #
  #
  def play
    self.sequence.each_with_index do |row, index|
      puts "#{index}: #{row.join(' , ')}"
    end
  end

  #
  # Play single row of sequence
  # 
  def play_row(index)
    row = self.sequence[index]
    master_commands(row[master_column].split(';'))
  end

  def master_commands(commands)
    if commands.any?
      commands.each do |command|
        command, value = command.split(' ')
        if command and value and MASTER_COMMANDS.include?(command)
          case command
           when 'time'
             self.pulse_count, self.pulse_resolution = value.split('/')
           when 'bpm'
             self.bpm = value
           when 'resolution'
             self.resolution = value
          end
        else 
          throw Error, "master commands must contain both a valid name (#{MASTER_COMMANDS.inspect}) and a value"
        end   
      end
      set_step_time
    end
  end

  def set_step_time
    unless self.pulse_count and self.pulse_resolution and self.bpm and self.resolution
      throw Error, "To set step time there must be a time signature, bpm and note resolution."
    end
    if self.compound_time?
      beat_milliseconds = MINUTE_MILLISEONDS / bpm
      rows_per_beat = self.resolution.to_f / self.pulse_resolution.to_f
      self.step_time = (beat_milliseconds.to_f / (rows_per_beat * 3)) 
    else # simple time
      beat_milliseconds = MINUTE_MILLISEONDS / bpm 
      rows_per_beat = self.resolution.to_f / self.pulse_resolution.to_f
      self.step_time = beat_milliseconds.to_f / rows_per_beat 
    end
  end  

  def compound_time?
    self.pulse_count / 3 == self.pulse_count.to_f / 3.0
  end

end

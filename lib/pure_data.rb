# PureData connection model
#
# Based on the Pd connection from Text to Music - May 2012
#
# https://github.com/AJFaraday/Text-to-music/blob/master/lib/pd-connect.rb
#

require 'socket'
require 'yaml'
require "#{File.dirname(__FILE__)}/note"

class PureData

  # allowed commands, see COMMAND_REFERENCE.md for more details

  ATTRIBUTES = [
    'volume', 
    'drum_level',
    'portamento_time',
    'attack_time',
    'decay_time',
    'sustain_level',
    'release_time',
    'fm_frequency',
    'fm_depth',
    'sq_width',
    'sq_depth',
    'sq_freq',
    'noise_attack',
    'noise_decay',
    'noise_f_freq',
    'noise_f_width',
    'noise_f_mod_freq',
    'noise_f_mod_depth',
    'snare_roll',
    'track_volume'
  ]

  BOOLEANS = [
    'portamento',
    'noise',
    'sine',
    'fm',
    'square',
    'sq_filter'
  ]

  EVENTS = [
    'kick',
    'snare',
    'hat',
    'tom1',
    'tom2',
    'tom3',
    'bells',
    'beep',
    'cymbal'
  ]

  attr_accessor :connections

  # 
  # Initializing an instance of PureData will set up a connection(TCPSocket) to the pure data patch. 
  # This should handle the lack of a config file, the patch being closed and an invalid hostname and/or port
  #
  def initialize
    self.connections = []
    begin
      config = YAML.load_file("#{File.dirname(__FILE__)}/../config/config.yml")
      puts "config profile: #{config['profile']}"
      connection_configs = config[config['profile']]['connections']
    rescue
      puts "config.yml not found, please copy it from the template and modify as required. (`cp config/config.yml.template config/config.yml`)"
      abort
    end
    connection_configs.each do |connection|
      hostname = connection['hostname']
      port = connection['port']
      begin
        sock = UDPSocket.new
        sock.connect(hostname, port)
        self.connections << sock
        if connection['volume']
        self.send_command((connections.length - 1), "track_volume #{connection['volume']}")
        else
          puts "Connection: #{connections.length - 1} is missing the volume attribute!"
          abort
        end
        puts "Connection established on #{hostname}:#{port}"
      rescue Errno::ECONNREFUSED, Errno::ENETUNREACH
        puts "Connection refused! Please ensure single.pd or quartet.pd is running in puredata and listening on #{hostname}:#{port}"
        abort
      rescue SocketError
        puts "Hostname and port are invalid. Please make sure they're a valid ip address and port number."
        abort
      rescue => er
        puts "Unknown error: #{er.message}"
        puts er.backtrace
        abort
      end
    end
  end

  # sends 'loadbang' signal to puredata to restore defaults
  def send_loadbang
    puts "sending loadbang"
    self.connections.each{|x|x.send "loadbang;\n", 0}
    # short gap to assure loadbang has time to take effect
    sleep 0.1
  end

  #
  # Generically send a command to pure data
  # 
  def send_command(connection_index, command)
    error = false
    command_parts = command.split(' ')
    command_name = command_parts[0].downcase
    if self.connections.count <= connection_index.to_i
      error = "Index: #{connection_index} is invalid, there are #{self.connections.count} connections."
    elsif PureData::ATTRIBUTES.include?(command_name)

      if command_parts.count == 2 
        command = "attribute #{command_name} #{command_parts[1].to_f}"
      else
        error = "Not a valid attribute command, should be name, then a number."
      end

    elsif PureData::BOOLEANS.include?(command_name.downcase)

      if command_parts.count == 2 and ['on','off'].include?(command_parts[1])
        command = "boolean #{command_name} #{command_parts[1] == 'on' ? 1 : 0}"
      else
        error = "Not a valid boolean command, should be the name, then 'on' or 'off'."
      end

    elsif PureData::EVENTS.include?(command_name.downcase)

      if command_parts.count == 1
        command = "event #{command}"
      else
        error = "Not a valid event command, should simply contain the event name, nothing else."
      end

    else
      error = "UNKNOWN COMMAND"
    end
    if error
      puts "ERROR on command \"#{command}\": #{error}"
    else
      #puts "#{connection_index}: #{command}"
      connections[connection_index.to_i].send "#{command};\n", 0
    end
  end

  #
  # Sends a general note message to a pd connection
  #
  def send_note(connection_index, note, length)
    note = Note.get_midi_number(note)
    command = "note #{note} #{length.to_f}" 
    #puts "#{connection_index}: #{command}"
    connections[connection_index.to_i].send "#{command};\n", 0
  end

end

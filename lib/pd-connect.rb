# PureData connection model
#
# Based on the Pd connection from Text to Music - May 2012
#
# https://github.com/AJFaraday/Text-to-music/blob/master/lib/pd-connect.rb
#

require 'socket'
require 'yaml'

class PureData

  # allowed commands, see COMMAND_REFERENCE.md for more details

  ATTRIBUTES = [
    'volume', 
    'portamento_time',
    'attack_time',
    'decay_time',
    'sustain_level',
    'release_time'
  ]

  BOOLEANS = [
    'portamento',
    'noise'
  ]

  EVENTS = [
    'kick',
    'snare',
    'hat',
    'beep'
  ]

  attr_accessor :connections

  # 
  # Initializing an instance of PureData will set up a connection(TCPSocket) to the pure data patch. 
  # This should handle the lack of a config file, the patch being closed and an invalid hostname and/or port
  #
  def initialize
    connections = []
    begin
      config = YAML.load_file("#{File.dirname(__FILE__)}../config/config.yml")
      connection_configs = config['connections']
    rescue
      puts "config.yml not found, please copy it from the template and modify as required. (`cp config/config.yml.template config/config.yml`)"
      abort
    end
    connection_configs.each do |connection|
      hostname = connection['hostname']
      port = connection['port']
      begin
        self.connections << TCPSocket.open hostname, port
        puts "Connection established on #{hostname}:#{port}"
      rescue Errno::ECONNREFUSED
        puts "Connection refused! Please ensure ruby_interact.pd is running in puredata and listening on #{hostname}:#{port}"
        abort
      rescue SocketError
        puts "Hostname and port are invalid. Please make sure they're a valid ip address and port number."
        abort
      end
    end
  end


  #
  # Generically send a command to pure data
  # 
  def send_command(connection_index, command)
    error = false
    command_parts = command.split(' ')
    command_name = command_parts[0]
    if PureData::ATTRIBUTES.include?(command_name)

      if command_parts.count == 2 
        command = "attribute #{command_name} #{command_parts[1].to_i}"
      else
        error = "Not a valid attribute command, should be name, then a number."
      end

    elsif PureData::BOOLEANS.include?(command_name)

      if command_parts.count == 2 and ['on','off'].include?(command_parts[1])
        command = "boolean #{command_name} #{command_parts == 'on' ? 1 : 0}"
      else
        error = "Not a valid boolean command, should be the name, then 'on' or 'off'."
      end

    elsif PureData::EVENTS.include?(command_name)

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
      puts "#{connection_index}: #{command}"
      connections[connection_index].puts command
    end
  end

  #
  # Sends a general note message to a pd connection
  #
  def send_note(connection_index, note, length)
    command = "note #{note} #{length}"
    puts "#{connection_index}: #{command}"
    connections[connection_index].puts command 
  end

end

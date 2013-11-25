# PureData connection model
#
# Based on the Pd connection from Text to Music - May 2012
#
# https://github.com/AJFaraday/Text-to-music/blob/master/lib/pd-connect.rb
#

require 'socket'
require './lib/character'
require 'yaml'

class PureData

  attr_accessor :connections
  attr_accessor :hostname
  attr_accessor :port

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
  # Accepts a string and separates it into it's individual characters and a speed (actually a rest time in seconds)
  # Outputs characters to the console one by one (typewriter effect)
  # Outputs suitable commands to the pure data patch
  # 
  def send_command(command)
    puts command
    connection.puts command
  end

end

require 'yum/version'
require 'csv'
require 'faraday'
require 'optparse'
require 'json'
require 'backendless'
require 'cli_parser'
require 'client'
require 'food'
require 'parser'
require 'request'
require 'user'
require 'yum_connector'

# Encapsulate the Yum application
module Yum
  # Uniters all main methods of user interface
  class Yummer
    # Unites Command Line parser methods
    def self.cli
      CliParser.parse_opts
      CliParser.parse_argv
    end
  end
end

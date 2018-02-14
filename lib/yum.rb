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

module Yum
  # Uniters all main methods of user interface
  class Yummer
    def self.cli
      CliParser.parse_opts
      CliParser.parse_argv
    end
  end
end

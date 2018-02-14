require 'yum/version'
require 'cli_parser'
require 'csv'

module Yum
  # Uniters all main methods of user interface
  class Yummer
    def self.cli
      CliParser.parse_opts
      CliParser.parse_argv
    end
  end
end

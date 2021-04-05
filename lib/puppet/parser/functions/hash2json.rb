require 'json'

module Puppet::Parser::Functions
  newfunction(:hash2json, :type => :rvalue, :doc => <<-EOS
    Simply transforms hash to JSON
    EOS
  ) do |arguments|
      return arguments[0].to_json
  end
end

# encoding: UTF-8
require 'active_support/all'
require 'active_support/version'
require 'mongo'

module Bin
  autoload :Compatibility, 'bin/compatibility'
  autoload :Store,         'bin/store'
  autoload :Version,       'bin/version'
end
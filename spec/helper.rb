$:.unshift(File.expand_path('../../lib', __FILE__))

require 'bin'
require 'spec'

connection = Mongo::Connection.new
DB = connection.db('bin-store-test')
$:.unshift(File.expand_path('../../lib', __FILE__))

gem 'activesupport', '<= 2.3.8'

require 'bin'
require 'spec'
require 'timecop'

connection = Mongo::Connection.new
DB = connection.db('bin-store-test')

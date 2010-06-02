gem 'activesupport', ENV['ACTIVE_SUPPORT_VERSION']

$:.unshift(File.expand_path('../../lib', __FILE__))

require 'bin'
require 'spec'
require 'timecop'

connection = Mongo::Connection.new
DB = connection.db('bin-store-test')

puts "\nRunning specs against Active Support version: #{ActiveSupport::VERSION::STRING}\n"
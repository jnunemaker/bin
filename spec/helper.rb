$:.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'bundler'
require 'active_support/all'

Bundler.require(:default)

require 'bin'

connection = Mongo::Connection.new
DB = connection.db('test')

RSpec.configure do |c|
  c.before(:each) do
    DB.collections.each do |collection|
      collection.remove
      collection.drop_indexes
    end
  end
end
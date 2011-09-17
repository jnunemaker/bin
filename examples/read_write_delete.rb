$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))
require 'active_support/all'
require 'bin'
require 'pp'

collection = Mongo::Connection.new.db('testing')['testing']
collection.remove

bin = Bin::Store.new(collection)
bin.write('abc', 123)
pp bin.read('abc')

pp bin.read('def')
pp bin.fetch('def') { 456 }
pp bin.read('def')

bin.delete('abc')
bin.delete('def')
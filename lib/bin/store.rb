# encoding: UTF-8
module Bin
  class Store < ActiveSupport::Cache::Store
    attr_reader :database

    def initialize(database)
      @database = database
    end

    def collection
      @database['active_support_cache']
    end

    def write(name, value, options=nil)
      super
      collection.save(:_id => name, :value => value)
    end

    def read(name, options=nil)
      super
      if doc = collection.find_one(:_id => name)
        doc['value']
      end
    end

    def delete(name, options=nil)
      super
      collection.remove(:_id => name)
    end

    def delete_matched(matcher, options=nil)
      super
      collection.remove(:_id => matcher)
    end

    def exist?(name, options=nil)
      super
      collection.find(:_id => name).count > 0
    end

    def clear
      collection.remove
    end
  end
end
# encoding: UTF-8
module Bin
  class Store < ActiveSupport::Cache::Store
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def write(name, value, options=nil)
      super
      doc = {:_id => name, :value => value}
      if options && options.key?(:expires_in)
        doc[:expires_at] = Time.now.utc + options[:expires_in]
      end
      collection.save(doc)
    end

    def read(name, options=nil)
      super
      if doc = collection.find_one(:_id => name)
        doc['value'] if fresh?(doc)
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

    def increment(key, amount=1)
      collection.update({:_id => key}, {'$inc' => {:value => amount}}, :upsert => true)
    end

    def decrement(key, amount=1)
      collection.update({:_id => key}, {'$inc' => {:value => -amount.abs}}, :upsert => true)
    end

    def stats
      collection.stats
    end

    private
      def fresh?(doc)
        doc['expires_at'].nil? || doc['expires_at'] > Time.now.utc
      end
  end
end
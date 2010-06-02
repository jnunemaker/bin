# encoding: UTF-8
module Bin
  class Store < ActiveSupport::Cache::Store
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def write(key, value, options=nil)
      super
      doc = {:_id => key, :value => value}
      if options && options.key?(:expires_in)
        doc[:expires_at] = Time.now.utc + options[:expires_in]
      end
      collection.save(doc)
    end

    def read(key, options=nil)
      super
      if doc = collection.find_one(:_id => key)
        doc['value'] if fresh?(doc)
      end
    end

    def delete(key, options=nil)
      super
      collection.remove(:_id => key)
    end

    def delete_matched(matcher, options=nil)
      super
      collection.remove(:_id => matcher)
    end

    def exist?(key, options=nil)
      super
      collection.find(:_id => key).count > 0
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
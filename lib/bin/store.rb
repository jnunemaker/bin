# encoding: UTF-8
module Bin
  class Store < Compatibility
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def write(key, value, options=nil)
      super do
        doc = {:_id => key, :value => value}
        if options && options.key?(:expires_in)
          doc[:expires_at] = Time.now.utc + options[:expires_in]
        end
        collection.save(doc)
      end
    end

    def read(key, options=nil)
      super do
        if doc = collection.find_one(:_id => key)
          doc['value'] if fresh?(doc)
        end
      end
    end

    def delete(key, options=nil)
      super do
        collection.remove(:_id => key)
      end
    end

    def delete_matched(matcher, options=nil)
      super do
        collection.remove(:_id => matcher)
      end
    end

    def exist?(key, options=nil)
      super do
        collection.find(:_id => key).count > 0
      end
    end

    def increment(key, amount=1)
      super do
        collection.update({:_id => key}, {'$inc' => {:value => amount}}, :upsert => true)
      end
    end

    def decrement(key, amount=1)
      super do
        collection.update({:_id => key}, {'$inc' => {:value => -amount.abs}}, :upsert => true)
      end
    end

    def clear
      collection.remove
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
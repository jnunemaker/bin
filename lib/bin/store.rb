# encoding: UTF-8
module Bin
  class Store < Compatibility
    attr_reader :collection, :options

    def initialize(collection, options={})
      @collection, @options = collection, options
    end

    def expires_in
      @expires_in ||= options[:expires_in] || 1.year
    end

    def write(key, value, options={})
      key = key.to_s
      super do
        expires = Time.now.utc + ((options && options[:expires_in]) || expires_in)
        raw     = !!options[:raw]
        value   = raw ? value : BSON::Binary.new(Marshal.dump(value))
        doc     = {:_id => key, :value => value, :expires_at => expires, :raw => raw}
        collection.save(doc)
      end
    end

    def read(key, options=nil)
      super do
        if doc = collection.find_one(:_id => key.to_s, :expires_at => {'$gt' => Time.now.utc})
          autoload_missing_constants do
            doc['raw'] ? doc['value'] : Marshal.load(doc['value'].to_s)
          end
        end
      end
    end

    def autoload_missing_constants
      yield
    rescue ArgumentError => error
      lazy_load ||= Hash.new { |hash, hash_key| hash[hash_key] = true; false }
      if error.to_s[/undefined class|referred/] && !lazy_load[error.to_s.split.last.sub(/::$/, '').constantize] then retry
      else raise error end
    end

    def delete(key, options=nil)
      super do
        collection.remove(:_id => key.to_s)
      end
    end

    def delete_matched(matcher, options=nil)
      super do
        collection.remove(:_id => matcher)
      end
    end

    def exist?(key, options=nil)
      super do
        !read(key, options).nil?
      end
    end

    def increment(key, amount=1)
      super do
        counter_key_upsert(key, amount)
      end
    end

    def decrement(key, amount=1)
      super do
        counter_key_upsert(key, -amount.abs)
      end
    end

    def clear
      collection.remove
    end

    def stats
      collection.stats
    end

    private
      def counter_key_upsert(key, amount)
        key = key.to_s
        collection.update(
          {:_id => key}, {
            '$inc' => {:value => amount},
            '$set' => {
              :expires_at => Time.now.utc + 1.year,
              :raw        => true
            },
          }, :upsert => true)
      end
  end
end

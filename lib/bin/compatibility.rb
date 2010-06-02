module Bin
  class Compatibility < ActiveSupport::Cache::Store
    def increment(key, amount=1)
      yield
    end

    def decrement(key, amount=1)
      yield
    end
  end

  if ActiveSupport::VERSION::STRING < '3'
    class Compatibility
      def write(key, value, options=nil, &block)
        super(key, value, options)
        yield
      end

      def read(key, options=nil, &block)
        super
        yield
      end

      def delete(key, options=nil, &block)
        super
        yield
      end

      def delete_matched(matcher, options=nil, &block)
        super
        yield
      end

      def exist?(key, options=nil, &block)
        super
        yield
      end
    end
  end
end
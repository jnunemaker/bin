require 'helper'

describe Bin::Store do
  before(:each) do
    DB.collections.each do |collection|
      collection.remove
      collection.drop_indexes
    end

    @collection = DB['active_support_cache']
    @store      = Bin::Store.new(@collection)
  end

  let(:store)       { @store }
  let(:collection)  { @collection }

  it "has a collection" do
    store.collection.should be_instance_of(Mongo::Collection)
    store.collection.name.should == 'active_support_cache'
  end

  describe "#write" do
    before(:each) do
      store.write('foo', 'bar')
    end
    let(:document) { collection.find_one(:_id => 'foo') }

    it "sets _id to key" do
      document['_id'].should == 'foo'
    end

    it "sets value key to value" do
      document['value'].should == 'bar'
    end

    it "sets expires_at if expires_in provided" do
      store.write('foo', 'bar', :expires_in => 5.seconds)
      document['expires_at'].to_i.should == (Time.now.utc + 5.seconds).to_i
    end
  end

  describe "#read" do
    before(:each) do
      store.write('foo', 'bar')
    end

    it "returns nil for key not found" do
      store.read('non:existent:key').should be_nil
    end

    it "returns value key value for key found" do
      store.read('foo').should == 'bar'
    end

    it "returns nil for existing but expired key" do
      collection.save(:_id => 'foo', :value => 'bar', :expires_at => 5.seconds.ago)
      store.read('foo').should be_nil
    end

    it "return value for existing and not expired key" do
      store.write('foo', 'bar', :expires_in => 20.seconds)
      store.read('foo').should == 'bar'
    end
  end

  describe "#delete" do
    before(:each) do
      store.write('foo', 'bar')
    end

    it "delete key from cache" do
      store.read('foo').should_not be_nil
      store.delete('foo')
      store.read('foo').should be_nil
    end
  end

  describe "#delete_matched" do
    before(:each) do
      store.write('foo1', 'bar')
      store.write('foo2', 'bar')
      store.write('baz', 'wick')
    end

    it "deletes matching keys" do
      store.read('foo1').should_not be_nil
      store.read('foo2').should_not be_nil
      store.delete_matched(/foo/)
      store.read('foo1').should be_nil
      store.read('foo2').should be_nil
    end

    it "does not delete unmatching keys" do
      store.delete_matched('foo')
      store.read('baz').should_not be_nil
    end
  end

  describe "#exist?" do
    before(:each) do
      store.write('foo', 'bar')
    end

    it "returns true if key found" do
      store.exist?('foo').should be_true
    end

    it "returns false if key not found" do
      store.exist?('not:found:key').should be_false
    end
  end

  describe "#clear" do
    before(:each) do
      store.write('foo', 'bar')
      store.write('baz', 'wick')
    end

    it "clear all keys" do
      collection.count.should == 2
      store.clear
      collection.count.should == 0
    end
  end

  describe "#increment" do
    it "increment key by amount" do
      store.increment('views', 1)
      store.read('views').should == 1
      store.increment('views', 2)
      store.read('views').should == 3
    end
  end

  describe "#decrement" do
    it "decrement key by amount" do
      store.increment('views', 5)
      store.decrement('views', 2)
      store.read('views').should == 3
      store.decrement('views', 2)
      store.read('views').should == 1
    end
  end

  describe "#stats" do
    it "returns stats" do
      %w[ns count size].each do |key|
        store.stats.should have_key(key)
      end
    end
  end
end
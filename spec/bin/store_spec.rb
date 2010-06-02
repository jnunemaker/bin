require 'helper'

describe Bin::Store do
  before(:each) do
    DB.collections.each do |collection|
      collection.remove
      collection.drop_indexes
    end

    @store      = Bin::Store.new(DB)
    @collection = DB['active_support_cache']
  end

  let(:store)       { @store }
  let(:collection)  { @collection }

  it "has database" do
    store.database.should == DB
  end

  it "has collection" do
    store.collection.should be_instance_of(Mongo::Collection)
    store.collection.name.should == 'active_support_cache'
  end

  describe "#write" do
    before(:each) do
      store.write('foo', 'bar')
    end

    it "sets _id to key" do
      collection.find_one(:_id => 'foo').should_not be_nil
    end

    it "sets value key to value" do
      collection.find_one(:_id => 'foo')['value'].should == 'bar'
    end
  end

  describe "#read" do
    before(:each) do
      collection.save(:_id => 'foo', :value => 'bar')
    end

    it "returns nil for key not found" do
      store.read('non:existent:key').should be_nil
    end

    it "returns value key value for key found" do
      store.read('foo').should == 'bar'
    end
  end

  describe "#delete" do
    before(:each) do
      collection.save(:_id => 'foo', :value => 'bar')
    end

    it "delete key from cache" do
      collection.find_one(:_id => 'foo').should_not be_nil
      store.delete('foo')
      collection.find_one(:_id => 'foo').should be_nil
    end
  end

  describe "#delete_matched" do
    before(:each) do
      collection.save(:_id => 'foo1', :value => 'bar')
      collection.save(:_id => 'foo2', :value => 'bar')
      collection.save(:_id => 'baz', :value => 'wick')
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
      collection.save(:_id => 'foo', :value => 'bar')
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
      collection.save(:_id => 'foo', :value => 'bar')
      collection.save(:_id => 'baz', :value => 'wick')
    end

    it "clear all keys" do
      collection.count.should == 2
      store.clear
      collection.count.should == 0
    end
  end
end
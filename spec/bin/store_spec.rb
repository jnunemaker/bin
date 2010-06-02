require 'helper'

describe Bin::Store do
  before(:each) do
    DB.collections.each do |collection|
      collection.remove
      collection.drop_indexes
    end
  end

  context "#initialize" do
    it "accept a database" do
      Bin::Store.new(DB).database.should == DB
    end
  end
end
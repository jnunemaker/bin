require 'helper'

describe Bin do
  it "autoloads Store" do
    lambda { Bin::Store }.should_not raise_error(NameError)
  end
end
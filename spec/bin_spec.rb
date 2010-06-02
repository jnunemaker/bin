require 'helper'

describe Bin do
  it "autoloads Store" do
    lambda { Bin::Store }.should_not raise_error(NameError)
  end

  it "autoloads Compatibility" do
    lambda { Bin::Compatibility }.should_not raise_error(NameError)
  end

  it "autoloads Version" do
    lambda { Bin::Version }.should_not raise_error(NameError)
  end
end
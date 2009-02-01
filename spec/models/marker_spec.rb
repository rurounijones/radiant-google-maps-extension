require File.dirname(__FILE__) + '/../spec_helper'

describe Marker do
  before(:each) do
    @marker = Marker.new
  end

  it "should be valid" do
    @marker.should be_valid
  end
end

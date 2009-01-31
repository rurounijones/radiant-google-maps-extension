require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleMap do
  before(:each) do
    @google_map = GoogleMap.new
  end

  it "should be valid" do
    @google_map.should be_valid
  end
end

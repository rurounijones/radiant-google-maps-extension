require File.dirname(__FILE__) + '/../spec_helper'

describe GoogleMap do
  dataset :google_maps
  test_helper :validations

  before :each do
    @google_map = @model = GoogleMap.new(google_map_params)
  end

  it 'should validate presence of' do
    [:name, :description, :latitude, :longitude].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end

  it "should validate presence, numericality and range of zoom" do
    assert_invalid :zoom, 'required', '', nil
    assert_invalid :zoom, 'must be an integer in the range 0 to 17 (inclusive)', ' ', '-1', '18', '3.5'
  end

  it "should validate presence of center" do
    @model.stub!(:create_point).and_return(nil)
    @model.center = nil
    @model.should_not be_valid
    @model.errors.on(:center).should eql("required")
  end

  it "should validate uniqueness of name" do
    assert_invalid :name, 'first'
    assert_valid :name, 'just-a-test'
  end
  
end
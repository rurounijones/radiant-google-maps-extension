require File.dirname(__FILE__) + '/../spec_helper'

describe Marker do
  dataset :markers
  test_helper :validations

  before :each do
    @marker = @model = Marker.new(marker_params)
  end

  it 'should validate presence of' do
    [:name, :title, :latitude, :longitude].each do |field|
      assert_invalid field, 'required', '', ' ', nil
    end
  end

  it 'should validate numericality of' do
    assert_invalid :google_map_id, 'required', '', nil
    [:google_map_id].each do |field|
      assert_valid field, '1', '2'
      assert_invalid field, 'must be a number', 'abcd', '1,2', '1.5'
    end
  end

  it "should validate presence of position" do
    @model.stub!(:create_point).and_return(nil)
    @model.position = nil
    @model.should_not be_valid
    @model.errors.on(:position).should eql("required")
  end

  #TODO: Make this test google map scope specific
  it "should validate uniqueness of name" do
    assert_invalid :name, 'first'
    assert_valid :name, 'just-a-test'
  end

  it 'should allow the filter to be specified' do
    @model = markers(:markdown)
    @model.filter.should be_kind_of(MarkdownFilter)
  end

  it "should validate presence, numericality and range of zoom" do
    assert_invalid :zoom, 'required', '', nil
    assert_invalid :zoom, 'must be an integer in the range 0 to 17 (inclusive)', ' ', '-1', '18', '3.5'
  end  

end
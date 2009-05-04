require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'Markers' do
  dataset :users, :markers

  before do
    login :admin
  end

  it 'should be able to create a new marker' do
    navigate_to "/admin/google_maps/#{google_map_id(:parent)}/markers/new"
    lambda do
      submit_form :marker => {:name => 'Mine', :title => "Mine Title", :content => 'Mine Content', :latitude => 0, :longitude => 0, :zoom => 5}
    end.should change(Marker, :count).by(1)
    response.should have_tag('#notice')
  end

  it "should display form errors" do
    navigate_to "/admin/google_maps/#{google_map_id(:parent)}/markers/new"
    lambda do
      submit_form :marker => {:name => 'Incomplete Map'}
    end.should_not change(Marker, :count)
    response.should have_tag("#error")
  end

  it "should redisplay the edit screen on 'Save & Continue Editing'" do
    navigate_to "/admin/google_maps/#{google_map_id(:parent)}/markers/new"
    submit_form :marker => {:name => 'Mine', :title => "Mine Title", :content => "Mine Content", :latitude => 0, :longitude => 0, :zoom => 5}, :continue => "Save and Continue"
    response.should have_tag('form')
    response.should have_tag('#notice')
    response.should have_text(/Mine Title/)
  end

  it "should allow you to delete a marker" do
    object = markers(:first)
    navigate_to "/admin/google_maps/#{google_map_id(:parent)}/markers/#{object.id}/remove"
    submit_form
    response.should be_showing("/admin/google_maps/#{google_map_id(:parent)}")
    response.should have_tag('#notice')
    response.should_not display_object(object)
  end
end

describe 'Marker as resource' do
  dataset :users, :markers

  before do
    @marker = Marker.create!(:name => 'Mine', :title => "Mine Title", :content => "Mine Content", :latitude => 0, :longitude => 0, :zoom => 5,  :google_map_id => google_map_id(:parent))
  end

  it 'should require authentication' do
    get "/admin/google_maps/#{google_map_id(:parent)}/markers/#{@marker.id}.xml"
    response.headers.keys.should include('WWW-Authenticate')
  end

  it 'should reject invalid creds' do
    get "/admin/google_maps/#{google_map_id(:parent)}/markers/#{@marker.id}.xml", nil, :authorization => encode_credentials(%w(admin badpassword))
    response.headers.keys.should include('WWW-Authenticate')
  end
end
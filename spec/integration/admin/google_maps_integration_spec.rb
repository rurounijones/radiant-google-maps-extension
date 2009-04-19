require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'GoogleMaps' do
  dataset :users, :google_maps

  before do
    login :admin
  end

  it 'should be able to go to google_maps tab' do
    click_on :link => '/admin/google_maps'
  end

  it 'should be able to create a new google_map' do
    navigate_to '/admin/google_maps/new'
    lambda do
      submit_form :google_map => {:name => 'Mine', :description => 'Test Map', :latitude => 0, :longitude => 0, :zoom => 0, :style => 1}
    end.should change(GoogleMap, :count).by(1)
  end

  it "should display form errors" do
    navigate_to '/admin/google_maps/new'
    lambda do
      submit_form :google_map => {:name => 'Incomplete Map'}
    end.should_not change(GoogleMap, :count)
    response.should have_tag("#error")
  end

  it "should redisplay the edit screen on 'Save & Continue Editing'" do
    navigate_to '/admin/google_maps/new'
    submit_form :google_map => {:name => 'Mine', :description => 'Test Map', :latitude => 0, :longitude => 0, :zoom => 0, :style => 1}, :continue => "Save and Continue"
    response.should have_tag('form')
    response.should have_tag('#notice')
    response.should have_text(/Test Map/)
  end

  it "should allow you to delete a google_map" do
    object = google_maps(:first)
    navigate_to "/admin/google_maps/#{object.id}/remove"
    submit_form
    response.should be_showing('/admin/google_maps')
    response.should have_tag('#notice')
    response.should_not display_object(object)
  end
end

describe 'GoogleMap as resource' do
  dataset :users

  before do
    @google_map = GoogleMap.create!(:name => 'Mine', :description => 'Test Map', :latitude => 0, :longitude => 0, :zoom => 0, :style => 1)
  end

  it 'should require authentication' do
    get "/admin/google_maps/#{@google_map.id}.xml"
    response.headers.keys.should include('WWW-Authenticate')
  end

  it 'should reject invalid creds' do
    get "/admin/google_maps/#{@google_map.id}.xml", nil, :authorization => encode_credentials(%w(admin badpassword))
    response.headers.keys.should include('WWW-Authenticate')
  end

  it 'should be obtainable by users' do
    get "/admin/google_maps/#{@google_map.id}.xml", nil, :authorization => encode_credentials(%w(admin password))
    response.body.should match(/xml/)
  end

  it 'should be obtainable as list' do
    get "/admin/google_maps.xml", nil, :authorization => encode_credentials(%w(admin password))
    response.body.should match(/google-maps/)
  end
end
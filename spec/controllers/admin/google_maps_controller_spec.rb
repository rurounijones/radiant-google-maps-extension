require File.dirname(__FILE__) + "/../../spec_helper"

describe Admin::GoogleMapsController do
  dataset :users, :google_maps

  before :each do
    ActionController::Routing::Routes.reload
    login_as :existing
  end

  it "should be an ResourceController" do
    controller.should be_kind_of(Admin::ResourceController)
  end

  it "should handle GoogleMaps" do
    controller.class.model_class.should == GoogleMap
  end

  {:get => [:index, :show, :new, :edit, :remove],
   :post => [:create],
   :put => [:update],
   :delete => [:destroy]}.each do |method, actions|
    actions.each do |action|
      it "should require login to access the #{action} action" do
        logout
        lambda { send(method, action, :id => google_map_id(:first)) }.should require_login
      end

      it "should allow access to developers for the #{action} action" do
        lambda {
          send(method, action, :id => google_map_id(:first))
        }.should restrict_access(:allow => [users(:developer)],
                                 :url => '/admin/pages')
      end

      it "should allow access to admins for the #{action} action" do
        lambda {
          send(method, action, :id => google_map_id(:first))
        }.should restrict_access(:allow => [users(:developer)],
                                 :url => '/admin/pages')
      end

      it "should allow non-developers and non-admins for the #{action} action" do
        lambda {
          send(method, action, :id => GoogleMap.first.id)
        }.should restrict_access(:allow => [users(:non_admin), users(:existing)],
                                 :url => '/admin/pages')
      end
    end
  end
end
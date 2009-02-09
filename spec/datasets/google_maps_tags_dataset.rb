class GoogleMapsTagsDataset < Dataset::Base
  uses :home_page, :markers

  def load
    create_page "Map", :body => "<r:google_map:header /><div id='mapDiv'></div><r:google_map:generate name='parent' div='mapDiv' />"#, :status_id => Status[:published].id, :published_at => Time.now - (10 - i).minutes
  end
end
namespace :radiant do
  namespace :extensions do
    namespace :google_maps do

      desc "Copies sample API key file of the Google Maps extension to the instance config/ directory."
      task :api do
        puts "Copying API key file from GoogleMapsExtension"
        # Can't init the environment because the YM4R plugin complains about missing key file (which this
        # task is creating). Therefore we can't use the GoogleMapsExtension.root constant to determine the path...
        # soooo lets hardcode it (What could possibly go wrong?)
        cp "#{RAILS_ROOT}/vendor/extensions/google_maps/gmaps_api_key.yml.sample", RAILS_ROOT + '/config/gmaps_api_key.yml'
      end

      desc "Runs the migration of the Google Maps extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          GoogleMapsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          GoogleMapsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Google Maps to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from GoogleMapsExtension"
        Dir[GoogleMapsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(GoogleMapsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end

        Dir[GoogleMapsExtension.root + "/vendor/plugins/ym4r_gm/javascript/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(GoogleMapsExtension.root + "/vendor/plugins/ym4r_gm/javascript/", '/public/javascripts/')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end

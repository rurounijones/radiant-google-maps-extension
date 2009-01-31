namespace :radiant do
  namespace :extensions do
    namespace :google_maps do
      
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
      end  
    end
  end
end

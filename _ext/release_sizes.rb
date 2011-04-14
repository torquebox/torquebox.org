require 'net/http'

class ReleaseSizes
  SERVER = 'repository.torquebox.org'

  def initialize()
  end

  def execute(site)
    Net::HTTP.start( SERVER, 80) do |http|
      (site.releases + site.old_releases).each do |release|
        if ( release.dist_size?.nil? )
          #release_path = "/maven2/releases/org/torquebox/torquebox-bin/#{release.version}/torquebox-bin-#{release.version}.zip" 
          release_path = release.urls.dist_zip
          response = http.head( release_path )
          b = response['content-length'] || ''
          if ( ! b.empty? )
            b = b.to_i
            kb = b / 1024
            mb = kb / 1024
            release.dist_size = mb
          else
            release.dist_size = 'unknown'
          end
        end
      end
    end
  end
end

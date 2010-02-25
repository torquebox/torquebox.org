require 'net/http'

class ReleaseSizes
  SERVER = 'repository.torquebox.org'

  def initialize()
  end

  def execute(site)
    Net::HTTP.start( SERVER, 80) do |http|
      site.releases.each do |release|
        if ( release.size.nil? )
          release_path = "/maven2/releases/org/torquebox/torquebox-bin/#{release.version}/torquebox-bin-#{release.version}.zip" 
          response = http.head( release_path )
          b = response['content-length'] || ''
          if ( ! b.empty? )
            b = b.to_i
            kb = b / 1024
            mb = kb / 1024
            release.size = mb
          else
            release.size = 'unknown'
          end
        end
      end
    end
  end
end

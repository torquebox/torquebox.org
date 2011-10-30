require 'net/http'
require 'uri'

class ReleaseSizes

  def initialize()
  end

  def execute(site)
    (site.releases + site.old_releases).each do |release|
      if ( release.dist_size?.nil? )
        uri = URI.parse( release.urls.dist_zip )
        Net::HTTP.start( uri.host, uri.port ) do |http|
          response = http.head( uri.path )
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

require 'net/http'
require 'uri'

class ReleaseSizes

  def initialize()
  end

  def execute(site)
    (site.releases).each do |release|
      if ( release.dist_size?.nil? && release.published )
        uri = URI.parse( release.urls.remote_dist_zip )
        release.dist_size = check_download_size( uri )
      end
      if ( release.eap_overlay? && release.eap_size?.nil? && release.published )
        uri = URI.parse( release.urls.remote_eap_zip )
        release.eap_size = check_download_size( uri )
      end
    end
  end

  def check_download_size(uri)
    Net::HTTP.start( uri.host, uri.port ) do |http|
      response = http.head( uri.path )
      b = response['content-length'] || ''
      if ( ! b.empty? )
        b = b.to_i
        kb = b / 1024
        mb = kb / 1024
        mb
      else
        'unknown'
      end
    end
  end
end

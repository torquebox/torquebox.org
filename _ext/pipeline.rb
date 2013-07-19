require 'rss_widget'
require 'documentation'
require 'release_sizes'
require 'downloads'
require 'release_helper'
require 'toc'
require 'events_munger'
require 'tagger_atomizer'
require 'tag_implier'
require 'json'
require 'podcasts'

# HACK: only until this gets fixed upstream in Awestruct
require 'digest/sha1'
class IntenseDebateFixed
  def execute(site)
    site.pages.each{|p| p.extend IntenseDebatable }
  end
  module IntenseDebatable
    def intense_debate_comments()
      post_id = self.post_id ? self.post_id : Digest::SHA1.hexdigest( self.url )
      html = %Q(<script>\n)
      html += %Q(  var idcomments_acct='#{site.intense_debate_acct}';\n)
      html += %Q(  var idcomments_post_id='#{post_id}';\n )
      html += %Q(  var idcomments_post_url='#{site.intense_debate_base_url || site.base_url}#{self.url}';\n)
      html += %Q(</script>\n)
      html += %Q(<span id="IDCommentsPostTitle" style="display:none"></span>\n)
      html += %Q(<script type='text/javascript' src='http://www.intensedebate.com/js/genericCommentWrapperV2.js'></script>\n)
      html
    end
    def intense_debate_comments_link()
      post_id = self.post_id ? self.post_id : Digest::SHA1.hexdigest( self.url )
      html = %Q(<script>\n)
      html += %Q(  var idcomments_acct='#{site.intense_debate_acct}';\n)
      html += %Q(  var idcomments_post_id='#{post_id}';\n )
      html += %Q(  var idcomments_post_url='#{site.intense_debate_base_url || site.base_url}#{self.url}';\n)
      html += %Q(</script>\n)
      html += %Q(<script type='text/javascript' src='http://www.intensedebate.com/js/genericLinkWrapperV2.js'></script>\n)
      html
    end
  end
end


Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::DataDir.new

  extension EventsMunger.new()
  extension Awestruct::Extensions::Atomizer.new(:events, '/events.atom')

  extension Downloads.new()

  extension ReleaseSizes.new()

  helper ReleaseHelper

  extension Awestruct::Extensions::Posts.new('/news')
  extension Awestruct::Extensions::TagImplier.new( :posts, [ :presentations, :conference, :conferences, :talks ], [ :event ] )
  extension Awestruct::Extensions::Paginator.new(:posts, '/news/index', :per_page => 5 )
  extension Awestruct::Extensions::Podcasts.new
  extension Awestruct::Extensions::Paginator.new(:podcasts, '/podcasts/index', :per_page => 5 )

  extension Awestruct::Extensions::Tagger.new( :podcasts, 
                                               '/podcasts/index', 
                                               '/podcasts/tags', 
                                               :per_page=>5 )
  extension Awestruct::Extensions::TagCloud.new( :podcasts, 
                                                 '/podcasts/tags/index.html',
                                                 :layout=>'default' )



  extension Awestruct::Extensions::Indexifier.new
  extension Awestruct::Extensions::Atomizer.new(:posts, '/news.atom')

  extension IntenseDebateFixed.new()

  extension Awestruct::Extensions::Tagger.new( :posts, 
                                               '/news/index', 
                                               '/news/tags', 
                                               :per_page=>5 )
  extension Awestruct::Extensions::TaggerAtomizer.new(:posts, '/news/tags' )

  extension Awestruct::Extensions::TagCloud.new( :posts, 
                                                 '/news/tags/index.html',
                                                 :layout=>'default' )


  extension TOC.new(:levels => 3)

  helper Awestruct::Extensions::GoogleAnalytics
  helper Awestruct::Extensions::Partial
  helper RssWidget

  extension Documentation.new()

  extension Awestruct::Extensions::Sitemap.new

end

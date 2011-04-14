require 'rss_widget'
require 'documentation'
require 'release_sizes'
require 'downloads'
require 'old_downloads'
require 'release_helper'
require 'toc'


Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::DataDir.new

  extension Documentation.new()


  extension Downloads.new()
  extension OldDownloads.new()

  extension ReleaseSizes.new()

  helper ReleaseHelper

  extension Awestruct::Extensions::Posts.new('/news')
  extension Awestruct::Extensions::Paginator.new(:posts, '/news/index', :per_page => 5 )
  extension Awestruct::Extensions::Indexifier.new
  extension Awestruct::Extensions::Atomizer.new(:posts, '/news.atom')
  extension Awestruct::Extensions::IntenseDebate.new()

  extension Awestruct::Extensions::Tagger.new( :posts, 
                                               '/news/index', 
                                               '/news/tags', 
                                               :per_page=>5 )

  extension Awestruct::Extensions::TagCloud.new( :posts, 
                                                 '/news/tags/index.html',
                                                 :layout=>'default' )


  extension TOC.new(:levels => 3)

  helper Awestruct::Extensions::GoogleAnalytics
  helper Awestruct::Extensions::Partial
  helper RssWidget
end

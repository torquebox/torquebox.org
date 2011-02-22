require 'rss_widget'
require 'release_sizes'
require 'documentation'
require 'downloads'
require 'release_helper'


Awestruct::Extensions::Pipeline.new do
  extension Documentation.new()
  extension Downloads.new()
  extension ReleaseSizes.new()
  extension Awestruct::Extensions::DataDir.new
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

  helper Awestruct::Extensions::GoogleAnalytics
  helper Awestruct::Extensions::Partial
  helper RssWidget
end

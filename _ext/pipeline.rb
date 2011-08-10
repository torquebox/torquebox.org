require 'rss_widget'
require 'documentation'
require 'release_sizes'
require 'downloads'
require 'old_downloads'
require 'release_helper'
require 'toc'
require 'events_munger'
require 'tagger_atomizer'
require 'tag_implier'


Awestruct::Extensions::Pipeline.new do
  extension Awestruct::Extensions::DataDir.new

  extension EventsMunger.new()
  extension Awestruct::Extensions::Atomizer.new(:events, '/events.atom')

  extension Downloads.new()
  extension OldDownloads.new()

  extension ReleaseSizes.new()

  helper ReleaseHelper

  extension Awestruct::Extensions::Posts.new('/news')
  extension Awestruct::Extensions::TagImplier.new( :posts, [ :presentations, :conference, :conferences, :talks ], [ :event ] )
  extension Awestruct::Extensions::Paginator.new(:posts, '/news/index', :per_page => 5 )
  extension Awestruct::Extensions::Indexifier.new
  extension Awestruct::Extensions::Atomizer.new(:posts, '/news.atom')
  extension Awestruct::Extensions::IntenseDebate.new()

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
end

require 'release_sizes'
require 'documentation'

require 'awestruct/extensions/intense_debate'

Awestruct::Extensions::Pipeline.new do
  extension Documentation.new()
  extension ReleaseSizes.new
  extension Awestruct::Extensions::Posts.new( '/news' )
  extension Awestruct::Extensions::Paginator.new( :posts, '/news/index', :per_page=>5 )
  extension Awestruct::Extensions::Indexifier.new
end


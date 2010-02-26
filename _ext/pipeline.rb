require 'release_sizes'

Awestruct::Extensions::Pipeline.new do
  extension ReleaseSizes.new
  extension Awestruct::Extensions::Posts.new( '/news' ) 
  extension Awestruct::Extensions::Indexifier.new
end


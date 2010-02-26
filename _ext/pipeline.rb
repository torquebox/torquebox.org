require 'release_sizes'
require 'documentation'

Awestruct::Extensions::Pipeline.new do
  extension Documentation.new()
  extension ReleaseSizes.new
  extension Awestruct::Extensions::Posts.new( '/news' ) 
  extension Awestruct::Extensions::Indexifier.new
end


require 'release_sizes'
require 'documentation'
require 'downloads'


Awestruct::Extensions::Pipeline.new do
  extension Documentation.new()
  extension Downloads.new()
  extension ReleaseSizes.new()
end


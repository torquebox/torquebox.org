require 'release_sizes'
require 'documentation'
require 'downloads'
require 'release_helper'


Awestruct::Extensions::Pipeline.new do
  extension Documentation.new()
  extension Downloads.new()
  extension ReleaseSizes.new()
  helper ReleaseHelper
end


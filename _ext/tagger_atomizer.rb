
module Awestruct
  module Extensions
    class TaggerAtomizer

      def initialize(tagged_items_property, output_path='tags' )
        @tagged_items_property = tagged_items_property
        @output_path = output_path
      end

      def execute(site)
        @tags = {}
        all = site.send( @tagged_items_property )
        return if ( all.nil? || all.empty? )

        all.each do |page|
          tags = page.tags
          if ( tags && ! tags.empty? )
            tags.each do |tag|
              tag = tag.to_s
              @tags[tag] ||= []
              @tags[tag] << page
            end
          end
        end

        @tags.each do |tag, pages|
          site.tagger_atomizer_entries = pages 
          atomizer = Awestruct::Extensions::Atomizer.new( :tagger_atomizer_entries, File.join( @output_path, "#{tag}.atom" ) )
          atomizer.execute( site )
          site.tagger_atomizer_entries = nil
        end

      end
    end
  end
end

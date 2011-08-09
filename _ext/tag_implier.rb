
module Awestruct
  module Extensions
    class TagImplier

      def initialize(tagged_items_property, match_tags, implied_tags)
        @tagged_items_property = tagged_items_property
        @match_tags = match_tags
        @implied_tags = implied_tags
      end

      def execute(site)
        all = site.send( @tagged_items_property )
        all.each do |page|
          tags = page.tags
          if ( @match_tags.any?{|e| tags.include?(e.to_s) } )
            @implied_tags.each do |t|
              unless tags.include?( t.to_s )
                page.tags << t.to_s
              end
            end
          end
        end

      end
    end
  end
end

module Awestruct
  module Extensions
    class Podcasts < Awestruct::Extensions::Posts

      DEFAULTS = {
        :path_prefix => '/podcasts', 
        :assign_to => :podcasts, 
        :output_path => '/podcasts.xml',
        :num_episodes => 50
      }

      attr_accessor :options

      def initialize( opts = {} )
        @options = DEFAULTS.merge( opts )
        super( options[:path_prefix], options[:assign_to] )
      end


      def execute(site)
        super( site )
        episodes = site.send( options[:assign_to] ) || []
        unless ( options[:num_episodes] == :all )
          episodes = episodes[0, options[:num_episodes]]
        end

        pages = []

        episodes.each do |episode|
          feed_episode = site.engine.load_page(episode.source_path, :relative_path => episode.relative_source_path, :html_entities => false)

          #feed_episode.output_path = episode.output_path
          feed_episode.date ||= feed_episode.timestamp.nil? ? episode.date : feed_episode.timestamp

          if feed_episode.enclosure && File.exist?( feed_episode.enclosure )
            stats = File::Stat.new( feed_episode.enclosure )
            feed_episode.length = stats.size
            episode.length = stats.size
          end

          episode.enclosure_mp4 = "#{base_media_url( feed_episode )}/#{feed_episode.enclosure_mp4}"
          episode.enclosure_ogg = "#{base_media_url( feed_episode )}/#{feed_episode.enclosure_ogg}"
          episode.itunes_image = "#{base_media_url( feed_episode )}/#{site.itunes.image}" 

          feed_episode.enclosure_mp4 = "#{base_media_url( feed_episode )}/#{feed_episode.enclosure_mp4}"
          feed_episode.enclosure_ogg = "#{base_media_url( feed_episode )}/#{feed_episode.enclosure_ogg}"
          feed_episode.itunes_image = "#{base_media_url( feed_episode )}/#{site.itunes.image}" 
          pages << feed_episode
        end

        site.engine.set_urls(pages)

        input_page = File.join( File.dirname(__FILE__), 'podcasts.xml.haml' )
        page = site.engine.load_page( input_page )
        page.date = page.timestamp unless page.timestamp.nil?
        page.output_path = options[:output_path]
        page.title = site.title || site.base_url
        page.itunes_image = "#{base_media_url( page )}/#{site.itunes.image}" 
        page.episodes = pages
        site.pages << page
      end

      def base_media_url( page )
        if is_not_blank? page.base_media_url
          #puts "USING BASE MEDIA URL page.base_media_url [#{page.base_media_url}]"
          page.base_media_url
        elsif is_not_blank? page.site.itunes.base_media_url
          #puts "USING BASE MEDIA URL page.site.itunes.base_media_url [#{page.site.itunes.base_media_url}]"
          page.site.itunes.base_media_url
        else
          #puts "USING BASE MEDIA URL page.site.base_media_url [#{page.site.base_media_url}]"
          page.site.base_media_url
        end
      end

      def is_not_blank?( thing )
        !thing.nil? && !thing == ''
      end
    end
  end
end

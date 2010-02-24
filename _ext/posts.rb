
class Posts
  def execute(site)
    news_posts = []

    site.pages.each do |page|
      if ( page.relative_source_path =~ /^news\/(20[01][0-9])-([01][0-9])-([0123][0-9])-(.*)\.html.haml$/ )
        year  = $1
        month = $2
        day   = $3
        slug  = $4
        page.date = Time.utc( year.to_i, month.to_i, day.to_i )
        page.slug = slug
        context = OpenStruct.new({
          :site=>site,
          :page=>page,
        })
        #page.body = page.render( context )
        page.output_path = "#{year}/#{month}/#{day}/#{slug}.html"
        news_posts << page
      end
    end
    
    news_posts = news_posts.sort_by{|each| [each.date, File.mtime( each.source_path ), each.slug ] }.reverse
    
    last = nil
    news_posts.each do |e|
      if ( last != nil )
         e.next = last
         last.previous = e
      end
      last = e
    end
    
    site.news_posts = news_posts
  end
end

class Post 
  attr_reader :year, :month, :day, :slug
  def initialize(config, year, month, day, slug, page)
    @config = config
    @year  = year
    @month = month
    @day   = day
    @slug  = slug
    @page  = page
    @page.extra_options['date'] = Time.utc( @year.to_i, @month.to_i, @day.to_i )
  end

  def body
    @page.render( @config, @page ) 
  end

  def method_missing(sym, *args)
    @page.send( sym, *args )
  end
end

news_posts = []

pages.each do |page|
  if ( page.path =~ /^#{site_root}\/news\/(20[01][0-9])-([01][0-9])-([0123][0-9])-(.*)\.html.haml$/ )
    year  = $1
    month = $2
    day   = $3
    slug  = $4
    news_posts << Post.new( config, year, month, day, slug, page )
  end
end

config['news_posts'] = news_posts.sort_by{|each| [each.year, each.month, each.day, File.mtime( each.path ), each.slug ] }.reverse


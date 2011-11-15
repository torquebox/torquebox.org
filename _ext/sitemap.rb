
class Sitemap

  def initialize( output_path, entries_name = :pages )
    @output_path  = output_path
    @entries_name = entries_name
  end

  def execute( site )
    # Get a bundle of pages we want to add to our sitemap
    # and set some metadata on them
    sitemap_pages = []
    entries = site.send( @entries_name )
    entries.each { |entry| sitemap_pages << set_sitemap_data( entry ) if valid_sitemap_entry( entry ) } if entries
    site.engine.set_urls( sitemap_pages )

    # Create a sitemap.xml file from our template
    sitemap = File.join( File.dirname(__FILE__), 'sitemap.xml.haml' )
    page                 = site.engine.load_page( sitemap )
    page.output_path     = @output_path
    page.sitemap_entries = sitemap_pages

    # Add the sitemap to our site
    site.pages << page
  end

  protected
  def set_sitemap_data( page )
    site = page.site
    page.date             ||= Time.now
    page.priority         ||= (site.priority or 0.1)
    page.change_frequency ||= (site.change_frequency or 'never')
    page
  end

  def valid_sitemap_entry( page )
    page.output_filename != '.htaccess'     &&
      page.output_filename  != 'screen.css' &&
      page.output_filename  != 'print.css'  &&
      page.output_filename  != 'ie.css'     &&
      page.output_filename  != 'robots.txt' &&
      page.output_extension != '.atom'      &&
      page.output_extension != '.scss'      &&
      page.output_extension != '.css'       &&
      page.output_extension != '.png'       &&
      page.output_extension != '.jpg'       &&
      page.output_extension != '.gif'       &&
      page.output_extension != '.js'
  end
end

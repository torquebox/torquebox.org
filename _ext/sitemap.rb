
class Sitemap

  def initialize( output_path, entries_name = :pages )
    @output_path  = output_path
    @entries_name = entries_name
  end

  def execute( site )
    entries = site.send( @entries_name )
    sitemap_pages = []

    entries.each do |entry|
      if valid_sitemap_entry( entry )
        sitemap_entry = site.engine.load_page(entry.source_path, :relative_path => entry.relative_source_path, :html_entities => false)
        sitemap_entry.output_path = entry.output_path
        sitemap_entry.date = last_update( entry, sitemap_entry )
        sitemap_entry.priority = 1
        sitemap_entry.change_frequency = change_frequency( entry, sitemap_entry )
        sitemap_pages << sitemap_entry
      end
    end

    site.engine.set_urls( sitemap_pages )

    sitemap = File.join( File.dirname(__FILE__), 'sitemap.xml.haml' )
    page = site.engine.load_page( sitemap )
    page.date = Time.now
    page.output_path = @output_path
    page.sitemap_entries = sitemap_pages
    page.title = site.title || site.base_url
    site.pages << page
  end

  protected
  def change_frequency( page, sitemap_entry )
    if page.change_frequency.nil?
      if sitemap_entry.change_frequency.nil?
        'never'
      else
        sitemap_entry.change_frequency
      end
    else
      page.change_frequency
    end
  end

  def last_update( page, sitemap_entry )
    if sitemap_entry.timestamp.nil? 
      page.date.nil? ? Time.now : page.date 
    else
      sitemap_entry.timestamp
    end
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

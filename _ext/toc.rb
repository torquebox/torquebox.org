class TOC
  def initialize(options = {})
    @options = {
        :levels => 2,
        :generate_header_links => false
    }.merge(options)
  end

  def execute(site)
    site.pages.each do |page|
      next unless page.toc
      toc = ""

      puts "syntax: #{page.content_syntax.inspect}"

      if page.content_syntax == :markdown
        toc = parse_markdown_headers(page.raw_content)
      elsif page.content_syntax == :textile
        toc = parse_textile_headers(page.raw_content)
      end

      page.table_of_contents = toc
      puts page.table_of_contents

    end
  end

  def titleable(title)
    title.strip.downcase.gsub(/\s+/, "_").gsub(/\W+/, "_").gsub(/_+/, '_').gsub(/_+$/, '')
  end

  def parse_markdown_headers(content)
    toc = ""
    last_depth = 0
    content.gsub!(/^(\#{1,6})[ ]+(.+?)[ ]*\#*\n+/) do |match|
      number = $1.size.to_i
      name = $2.strip
      header = titleable(name)

      if ( number > last_depth ) 
        last_depth.upto( number -1) do |e|
          toc << "<ul>"
        end
      elsif ( number.to_i < last_depth )
        last_depth.downto( number +1 ) do |e|
          toc << "</ul>"
        end
      end

      toc << "<li><a href='##{header}'>#{name}</a></li>" 

      last_depth = number

      "<h#{number} id=\"#{header}\">#{name}</h#{number}>\n\n"
    end

    number = 1
    if ( number.to_i < last_depth )
      last_depth.downto( number ) do |e|
        toc << "</ul>"
      end
    end

    toc
  end

end

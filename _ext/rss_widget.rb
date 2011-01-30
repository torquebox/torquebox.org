module RssWidget

  # Insert RSS feed entries into the page. This plugin relies on jQuery
  # and zRSSFeed from http://www.zazar.net/developers/zrssfeed/default.html
  #
  # jQuery License:
  # http://jquery.org/license
  #
  # zRSSFeed License:
  # http://www.zazar.net/developers/zrssfeed/default.html#license
  #
  # Parameters:
  # div_id is the id to give the div containing the feed entries
  # feed_url is the absolute URL of the RSS feed
  # options are any options supported by zRSSFeed, as a Ruby hash
  #
  def rss_widget(div_id, feed_url, options = {})
    options = javascript_options(options)
    html = ''
    html += %Q(<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>\n)
    html += %Q(<script type="text/javascript">#{minified_zrssfeed}</script>\n)
    html += %Q(<div id="#{div_id}"></div>\n)
    html += %Q(<script type="text/javascript">\n)
    html += %Q(  $\(document\).ready\(function\(\) {\n)
    html += %Q(    $\('##{div_id}'\).rssfeed\('#{feed_url}', #{options}\);\n)
    html += %Q(  }\);\n)
    html += %Q(</script>\n)
    html
  end

  def javascript_options(options)
    pairs = options.map do |key ,value|
      javascript_value = value.is_a?(String) ? "'#{value}'" : value
      "#{key}: #{javascript_value}"
    end
    "{ #{pairs.join(', ')} }"
  end

  # Minified zRSSFeed included inline so we don't have to rely on an
  # external javascript file
  def minified_zrssfeed
    <<EOS
(function($){var current=null;$.fn.rssfeed=function(url,options){var defaults={limit:10,header:true,titletag:'h4',date:true,content:true,snippet:true,showerror:true,errormsg:'',key:null};var options=$.extend(defaults,options);return this.each(function(i,e){var $e=$(e);if(!$e.hasClass('rssFeed'))$e.addClass('rssFeed');if(url==null)return false;var api="http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&callback=?&q="+url;if(options.limit!=null)api+="&num="+options.limit;if(options.key!=null)api+="&key="+options.key;$.getJSON(api,function(data){if(data.responseStatus==200){_callback(e,data.responseData.feed,options);}else{if(options.showerror)
if(options.errormsg!=''){var msg=options.errormsg;}else{var msg=data.responseDetails;};$(e).html('<div class="rssError"><p>'+msg+'</p></div>');};});});};var _callback=function(e,feeds,options){if(!feeds){return false;}
var html='';var row='odd';if(options.header)
html+='<div class="rssHeader">'+'<a href="'+feeds.link+'" title="'+feeds.description+'">'+feeds.title+'</a>'+'</div>';html+='<div class="rssBody">'+'<ul>';for(var i=0;i<feeds.entries.length;i++){var entry=feeds.entries[i];var entryDate=new Date(entry.publishedDate);var pubDate=entryDate.toLocaleDateString()+' '+entryDate.toLocaleTimeString();html+='<li class="rssRow '+row+'">'+'<'+options.titletag+'><a href="'+entry.link+'" title="View this feed at '+feeds.title+'">'+entry.title+'</a></'+options.titletag+'>'
if(options.date)html+='<div>'+pubDate+'</div>'
if(options.content){if(options.snippet&&entry.contentSnippet!=''){var content=entry.contentSnippet;}else{var content=entry.content;}
html+='<p>'+content+'</p>'}
html+='</li>';if(row=='odd'){row='even';}else{row='odd';}}
html+='</ul>'+'</div>'
    $(e).html(html);};})(jQuery);
EOS
  end

end

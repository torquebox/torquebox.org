
require 'rubygems'
require 'versionomy'

class OldDownloads


  FORMAT = Versionomy.default_format.modified_copy do
             field(:release_type, :requires_previous_field => false,
                   :default_style => :short) do
               recognize_regexp_map(:style => :long, :default_delimiter => '',
                                    :delimiter_regexp => '-|\.|\s?') do
                 map(:development, 'Dev')
                 map(:alpha, 'Alpha')
                 map(:beta, 'Beta')
                 map(:preview, 'Preview')
               end
             end
           end

  REPO_PREFIX = "http://repository.torquebox.org/maven2/releases/org/torquebox"
  DOCS_PREFIX = "#{REPO_PREFIX}/torquebox-docs-en_US"

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    site.old_releases.each do |release|
      v = Versionomy.parse( release.version, FORMAT )
      all_releases(release)
      if ( v.major == 1 && v.minor == 0 && v.beta_version < 21 ) 
        before_beta21(release)
      else
        after_beta21(release)
      end
      if ( v.major == 1 && v.minor == 0 && v.beta_version < 22 ) 
        before_beta22(release)
      else
        after_beta22(release)
      end
    end
  end

  def all_releases(release)
    release.urls      ||= OpenStruct.new
    release.urls.docs ||= OpenStruct.new
    release.urls.docs.browse          = "/documentation/#{release.version}/"
    release.urls.docs.pdf             = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}.pdf"
    release.urls.docs.html_multi_zip  = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip"

    release.urls.jira = "https://jira.jboss.org/jira/secure/IssueNavigator.jspa?reset=true&amp;fixfor=#{release.jira_version}&amp;pid=12310812&amp;sorter/field=issuekey&amp;sorter/order=DESC"

    release.urls.github ||= OpenStruct.new
    release.urls.github.log = "http://github.com/torquebox/torquebox/commits/#{release.version}"
    release.urls.github.tree = "http://github.com/torquebox/torquebox/tree/#{release.version}"
  end
  
  def before_beta21(release)
    release.urls.dist_zip = "#{REPO_PREFIX}/torquebox-bin/#{release.version}/torquebox-bin-#{release.version}.zip"
  end

  def after_beta21(release)
    release.urls.dist_zip = "#{REPO_PREFIX}/torquebox-dist/#{release.version}/torquebox-dist-#{release.version}-bin.zip"
  end

  def before_beta22(release)
    release.urls.docs.html_single_zip = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html-single.zip"
  end

  def after_beta22(release)
  end

end

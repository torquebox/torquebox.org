
require 'rubygems'
require 'versionomy'

class Downloads


  FORMAT = Versionomy.default_format.modified_copy do
             field(:release_type, :requires_previous_field => false,
                   :default_style => :short) do
               recognize_regexp_map(:style => :long, :default_delimiter => '',
                                    :delimiter_regexp => '-|\.|\s?') do
                 map(:development, 'Dev')
                 map(:alpha, 'Alpha')
                 map(:beta, 'Beta')
                 map(:release_candidate, 'CR')
               end
             end
           end

  REPO_PREFIX = "http://repository-projectodd.forge.cloudbees.com/release/org/torquebox"
  LOCAL_REPO_PREFIX = "/release/org/torquebox"
  DOCS_PREFIX = "#{LOCAL_REPO_PREFIX}/torquebox-docs-en_US"
  REMOTE_DOCS_PREFIX = "#{REPO_PREFIX}/torquebox-docs-en_US"

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    site.releases.each do |release|
      v = Versionomy.parse( release.version, FORMAT )

      case ( v )
        when ( v('1.0.0.CR1')..('2.0') )
          all_releases(v, release)
          release_suffix = "/torquebox-dist/#{release.version}/torquebox-dist-#{release.version}-bin.zip"
          release.urls.dist_zip = "#{LOCAL_REPO_PREFIX}#{release_suffix}"
          release.urls.remote_dist_zip = "#{REPO_PREFIX}#{release_suffix}"
      end
    end
  end

  def v(version)
    Versionomy.parse( version, FORMAT )
  end

  def all_releases(version, release)
    release.urls      ||= OpenStruct.new
    release.urls.docs ||= OpenStruct.new
    release.urls.docs.browse                = "/documentation/#{release.version}/"
    release.urls.docs.pdf                   = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}.pdf"
    release.urls.docs.html_multi_zip        = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip"
    release.urls.docs.remote_html_multi_zip = "#{REMOTE_DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip"

    if ( (v('1.0.0.CR2')..v('2.0')).include?( version ) )
      release.urls.docs.epub          = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}.epub"
    end


    release.urls.jira = "https://jira.jboss.org/jira/secure/IssueNavigator.jspa?reset=true&jqlQuery=project=TORQUE+AND+fixVersion=#{release.jira_version}&sorter/field=issuekey&sorter/order=DESC"

    release.urls.github ||= OpenStruct.new
    release.urls.github.log = "http://github.com/torquebox/torquebox/commits/#{release.version}"
    release.urls.github.tree = "http://github.com/torquebox/torquebox/tree/#{release.version}"
  end
  
  def before_beta21(release)
    release_suffix = "/torquebox-bin/#{release.version}/torquebox-bin-#{release.version}.zip"
    release.urls.dist_zip = "#{LOCAL_REPO_PREFIX}#{release_suffix}"
    release.urls.remote_dist_zip = "#{REPO_PREFIX}#{release_suffix}"
  end

  def after_beta21(release)
    release_suffix = "/torquebox-dist/#{release.version}/torquebox-dist-#{release.version}-bin.zip"
    release.urls.dist_zip = "#{LOCAL_REPO_PREFIX}#{release_suffix}"
    release.urls.remote_dist_zip = "#{REPO_PREFIX}#{release_suffix}"
  end

  def before_beta22(release)
    release.urls.docs.html_single_zip = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html-single.zip"
  end

  def after_beta22(release)
  end

end

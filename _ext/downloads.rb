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

  VERSION_RANGE      = Range.new(Versionomy.parse('1.0.0', FORMAT), Versionomy.parse('2.99', FORMAT))
  REPO_PREFIX        = "http://repository-projectodd.forge.cloudbees.com/release/org/torquebox"
  LOCAL_REPO_PREFIX  = "/release/org/torquebox"
  DOCS_PREFIX        = "#{LOCAL_REPO_PREFIX}/torquebox-docs-en_US"
  REMOTE_DOCS_PREFIX = "#{REPO_PREFIX}/torquebox-docs-en_US"

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    site.releases.each do |release|
      version = Versionomy.parse( release.version, FORMAT )
      if release.published = version.published?
        all_releases(version, release)
        release_suffix                = "/torquebox-dist/#{release.version}/torquebox-dist-#{release.version}-bin.zip"
        release.urls.dist_zip         = "#{LOCAL_REPO_PREFIX}#{release_suffix}"
        release.urls.remote_dist_zip  = "#{REPO_PREFIX}#{release_suffix}"
      end
    end
  end

  def all_releases(version, release)
    release.urls      ||= OpenStruct.new
    release.urls.docs ||= OpenStruct.new
    release.urls.docs.browse                = "/documentation/#{release.version}/"
    if release.api_docs === true
      release.urls.docs.javadocs            = "/documentation/#{release.version}/javadoc/"
      release.urls.docs.yardocs             = "/documentation/#{release.version}/yardoc/"
    end
    
    release.urls.docs.pdf                   = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}.pdf"
    release.urls.docs.html_multi_zip        = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip"
    release.urls.docs.remote_html_multi_zip = "#{REMOTE_DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip"
    release.urls.docs.epub                = "#{DOCS_PREFIX}/#{release.version}/torquebox-docs-en_US-#{release.version}.epub" 

    release.urls.jira = "https://jira.jboss.org/jira/secure/IssueNavigator.jspa?reset=true&jqlQuery=project=TORQUE+AND+fixVersion=#{release.jira_version}&sorter/field=issuekey&sorter/order=DESC"

    release.urls.github ||= OpenStruct.new
    release.urls.github.log = "http://github.com/torquebox/torquebox/commits/#{release.version}"
    release.urls.github.tree = "http://github.com/torquebox/torquebox/tree/#{release.version}"
  end
  
end

module Versionomy
  @@ruby_version = parse(RUBY_VERSION)

  def self.published? version
    @@ruby_version.minor == 8 ? Downloads::VERSION_RANGE.include?( version ) : Downloads::VERSION_RANGE.cover?( version )
  end

  class Value
    def published?
      Versionomy.published? self
    end
  end
end



class Documentation
  API_DOC_REPO = "http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-complete/"

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    @tmp_dir = site.tmp_dir

    current_docs_path = File.join( site.output_dir, 'documentation', 'current' )
    FileUtils.rm( current_docs_path ) if File.exist?( current_docs_path )
    current_guide_path = File.join( site.output_dir, 'getting-started', 'current' )
    FileUtils.rm( current_guide_path) if File.exist?( current_guide_path )

    (site.releases).each do |release|
      doc_bundle_name = "torquebox-docs-en_US-#{release.version}-html.zip"
      doc_root = File.join( site.output_dir, 'documentation', release.version )
      FileUtils.mkdir_p( doc_root )

      getting_started_bundle_name = "torquebox-docs-getting-started-en_US-#{release.version}-html.zip"
      getting_started_root = File.join( site.output_dir, 'getting-started', release.version )
      FileUtils.mkdir_p( getting_started_root )

      if release == site.releases.first
        #puts "Linking documentation/current to #{release.version}"
        FileUtils.cd( File.join( site.output_dir, 'documentation' ) ) do |dir|
          FileUtils.ln_s( release.version, 'current' )
        end

        FileUtils.cd( File.join( site.output_dir, 'getting-started' ) ) do |dir|
          FileUtils.ln_s( release.version, 'current' )
        end
      end

      unless bundle_exists?( doc_bundle_name )
        puts "Fetching doc bundle for #{release.version}"
        dl( release.urls.docs.remote_html_multi_zip )
      end

      unless File.exist?( File.join( doc_root, "index.html" ) )
        puts "Unzipping doc bundle for #{release.version}"
        unzip( bundle_path( doc_bundle_name ), doc_root )
        add_analytics( site, doc_root )
      end

      if release.getting_started_guide == true
        unless bundle_exists?( getting_started_bundle_name )
          puts "Fetching getting started bundle for #{release.version}"
          dl( release.urls.getting_started.remote_html_multi_zip )
        end

        unless File.exist?( File.join( getting_started_root, "index.html" ) )
          puts "Unzipping getting started bundle for #{release.version}"
          unzip( bundle_path( getting_started_bundle_name ), getting_started_root )
          add_analytics( site, getting_started_root )
        end
      end

      if release.api_docs === true
        api_docs( site, release.version, 'javadoc', doc_root )
        api_docs( site, release.version, 'yardoc', doc_root )
      end

    end

    api_docs_4x(site)
  end

  def api_docs(site, version, type, root)
    bundle_name = "torquebox-complete-#{version}-#{type}s.jar"
    url = API_DOC_REPO + version + "/#{bundle_name}"

    unless bundle_exists?( bundle_name )
      puts "Fetching #{type} bundle for #{version}"
      dl( url )
    end

    output_dir = File.join( root, type )
    if bundle_exists?( bundle_name ) && !File.exist?( output_dir )
      puts "Unzipping #{type} bundle for #{version}"
      FileUtils.mkdir_p( output_dir )
      unzip( bundle_path( bundle_name ), output_dir )
      add_analytics( site, output_dir )
    end
  end

  def api_docs_4x(site)
    Dir.glob("_4x_docs/*").each do |dir|
      version = File.basename(dir)
      doc_root = File.join(site.output_dir, 'documentation', version)
      puts "!Copying docs for #{version}"
      FileUtils.cp_r(dir, doc_root)
      add_analytics(site, doc_root)
    end
  end

  def bundle_exists?(name)
    File.exist?( bundle_path( name ) )
  end

  def bundle_path(name)
    File.join( @tmp_dir, name )
  end

  def unzip(bundle, dest)
    `unzip -q #{bundle} -d #{dest}`
  end

  def dl(url, dir = @tmp_dir)
    `wget --quiet -P #{dir} #{url}`
  end

  def add_analytics(site, root)
    analytics_code = AnalyticsHelper.new(site).google_analytics
    Dir.glob( "#{root}/**/*.html" ).each do |path|
      contents = File.read( path )
      contents.sub!(/(<\/body>)/i, "#{analytics_code}\\1")
      File.write( path, contents )
    end
  end

  class AnalyticsHelper
    include Awestruct::Extensions::GoogleAnalytics
    attr_reader :site
    def initialize(site)
      @site = site
    end
  end

end

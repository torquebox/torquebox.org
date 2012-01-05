
class Documentation
  API_DOC_REPO = "http://repository-projectodd.forge.cloudbees.com/release/org/torquebox/torquebox-complete/"
  
  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    @tmp_dir = site.tmp_dir
    
    current_path = File.join( site.output_dir, 'documentation', 'current' ) 
    FileUtils.rm( current_path ) if File.exist?( current_path )

    (site.releases).each do |release|
      doc_bundle_name = "torquebox-docs-en_US-#{release.version}-html.zip"
      doc_root = File.join( site.output_dir, 'documentation', release.version )
      FileUtils.mkdir_p( doc_root )

      if release == site.releases.first
        #puts "Linking documentation/current to #{release.version}"
        FileUtils.cd( File.join( site.output_dir, 'documentation' ) ) do |dir|
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
      end

      if release.api_docs === true
        api_docs( release.version, 'javadoc', doc_root )
        api_docs( release.version, 'yardoc', doc_root )
      end
      
    end
  end

  def api_docs(version, type, root)
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
  
end

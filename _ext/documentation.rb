
class Documentation

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    FileUtils.cd( File.join( site.output_dir, 'documentation' ) ) do |dir|
      FileUtils.rm( 'current' ) if File.exist?( 'current' )
    end

    site.releases.each_with_index do |release, index|
      doc_bundle_name = "torquebox-docs-en_US-#{release.version}-html.zip"
      doc_bundle_path = File.join( site.tmp_dir, doc_bundle_name )
      doc_root = File.join( site.output_dir, 'documentation', release.version )
      FileUtils.mkdir_p( doc_root )

      if index == 0
        puts "Linking documentation/current to #{release.version}"
        FileUtils.cd( File.join( site.output_dir, 'documentation' ) ) do |dir|
          FileUtils.ln_s( release.version, 'current' ) 
        end
      end
      
      unless ( File.exist?( doc_bundle_path ) )
        puts "Fetching doc bundle for #{release.version}"
        `wget --quiet -P #{site.tmp_dir} http://repository.torquebox.org/maven2/releases/org/torquebox/torquebox-docs-en_US/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip`
      end
      unless ( File.exist?( File.join( doc_root, "index.html" ) ) )
        puts "Unzipping doc bundle for #{release.version}"
        `unzip -q #{doc_bundle_path} -d #{doc_root}`
      end
    end
  end
end

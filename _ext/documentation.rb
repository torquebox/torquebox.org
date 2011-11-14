
class Documentation

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled

    current_path = File.join( site.output_dir, 'documentation', 'current' ) 
    FileUtils.rm( current_path ) if File.exist?( current_path )

    (site.releases).each do |release|
      doc_bundle_name = "torquebox-docs-en_US-#{release.version}-html.zip"
      doc_bundle_path = File.join( site.tmp_dir, doc_bundle_name )
      doc_root = File.join( site.output_dir, 'documentation', release.version )
      FileUtils.mkdir_p( doc_root )

      if release == site.releases.first
        #puts "Linking documentation/current to #{release.version}"
        FileUtils.cd( File.join( site.output_dir, 'documentation' ) ) do |dir|
          FileUtils.ln_s( release.version, 'current' ) 
        end
      end
      
      unless ( File.exist?( doc_bundle_path ) )
        puts "Fetching doc bundle for #{release.version}"

        doc_url = release.urls.docs.html_multi_zip

        `wget --quiet -P #{site.tmp_dir} #{doc_url}`
      end
      unless ( File.exist?( File.join( doc_root, "index.html" ) ) )
        puts "Unzipping doc bundle for #{release.version}"
        `unzip -q #{doc_bundle_path} -d #{doc_root}`
      end
    end
  end
end

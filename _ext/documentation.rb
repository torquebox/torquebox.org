
class Documentation

  def initialize(enabled=true)
    @enabled = enabled
  end

  def execute(site)
    return unless @enabled
    site.releases.each do |release|
      doc_root = File.join( site.output_dir, 'documentation', release.version )
      FileUtils.mkdir_p( doc_root )
      simple_name = "torquebox-docs-en_US-#{release.version}-html.zip"
      unless ( File.exist?( File.join( doc_root, simple_name ) ) ) 
        puts "Fetching doc bundle for #{release.version}"
        `wget --quiet -P #{doc_root} http://repository.torquebox.org/maven2/releases/org/torquebox/torquebox-docs-en_US/#{release.version}/torquebox-docs-en_US-#{release.version}-html.zip`
      end
      unless ( File.exist?( File.join( doc_root, "index.html" ) ) )
        Dir.chdir( doc_root ) do
          puts "Unzipping doc bundle for #{release.version}"
          `unzip -q #{simple_name}`
        end
      end
    end
  end
end



module ReleaseHelper

  def release_for_version(version)
    site.releases.find{|e| e.version == version } || site.old_releases.find{|e| e.version == version }
  end

end

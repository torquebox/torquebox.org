

module ReleaseHelper

  def release_for_version(version)
    site.releases.find{|e| e.version == version }
  end

  def taco
    "taco"
  end

end

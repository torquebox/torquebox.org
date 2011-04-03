
function Jenkins(url, job) {
  this.url = url;
  this.job = job;
  this.builds = {} ;
  this.root_data = {};
  this.initialize();
}

Jenkins.prototype = {
  initialize: function() {
    var self = this;
    $.ajax( { 
      url: this.job_url('/api/json' ),
      jsonp: 'jsonp',
      dataType: 'jsonp',
      type: 'GET',
      context: self,
      async: false,
      success: self.handle_job_jsonp,
    } );
  },

  handle_job_jsonp: function(data) {
    var self = this;
    self.root_data = data;
    $.each( data.builds.slice(0,20), function(i,build) {
      self.fetch_build_details( build );
    } );
    $(document).ajaxStop( function() { self.update_page(self) } );
  }, 

  update_page: function(self) {
    $.each( self.root_data.builds, function(i,build) {
      self.add_row( $('#builds'), self.builds[build.number]);
    } );

    self.add_row( $('#latest-stable'), self.builds[ self.root_data.lastStableBuild.number ] );
  },
  
  fetch_build_details: function(build_summary) {
    var self = this;
    $.ajax( {
      url: build_summary.url + '/api/json',
      jsonp: 'jsonp',
      dataType: 'jsonp',
      type: 'GET',
      context: self,
      async: false,
      success: self.handle_build_jsonp,
    } );
  },

  handle_build_jsonp: function(data) {
    var self = this;
    self.builds[ data.number ] = data;
  },

  add_row: function(table, build) {
    var self = this;
    build_result_class = "unknown";
    if ( build.result ) {
      build_result_class = 'result-' + build.result.toLowerCase();
    } else {
      if ( build.building ) {
        build_result_class = 'result-building';
      }
    }
    row = $( '<tr class="build ' + build_result_class + '"></td>' );

    row.append( $( '<td class="col-build"></td>' ) );
    row.append( $( '<td class="col-dist"></td>' ) );
    row.append( $( '<td class="col-docs"><ul></ul></td>' ) );
    row.append( $( '<td class="col-changes"><a href="' + build.url + '/changes">Changes</a></td>' ) );
    row.append( $( '<td class="col-git"><ul></ul></td>' ) );

    last_built_revision = build.actions[1].lastBuiltRevision;

    git_revision = null;

    if ( last_built_revision ) {
      git_revision = build.actions[1].lastBuiltRevision.SHA1;
      short_git_revision = git_revision.substring(0, 8);
    }

    // Build
    release_date = new Date( build.timestamp );
    formatted_time = release_date.format( "dd mmmm yyyy" ) + '<br/>' + release_date.format( "HH:MM" ) + ' US Eastern<br/>';

    if ( git_revision ) {
      formatted_time += '<a href="https://github.com/torquebox/torquebox/commits/' + git_revision + '">' + short_git_revision + '</a>';
    }
    row.find( '.col-build' ).append( $( '<div class="version"><a href="' + build.url + '">' + build.number + '</div>' ) );
    row.find( '.col-build' ).append( $( '<div class="release-date">' + formatted_time + '</div>' ) );

    // Dist
    dist_bin_artifact = self.locate_artifact(build, 'dist/target/torquebox-dist-bin.zip' );
    if ( dist_bin_artifact ) {
      row.find( '.col-dist' ).append( $( '<a href="/builds/' +  build.number + '/torquebox-dist-bin.zip">Download ZIP</a>' ) );
    }

    // Docs
    html_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/xhtml/index.html' );
    if ( html_doc_artifact ) {
      row.find( '.col-docs ul' ).append( $( '<li><a href="' + self.job_url( build.number + '/artifact/' + html_doc_artifact.relativePath) + '">Browse </a></li>' ) );
    }

    pdf_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/pdf/torquebox-docs-en_US.pdf' );
    if ( pdf_doc_artifact ) {
      row.find( '.col-docs ul' ).append( $( '<li><a href="' + self.job_url( build.number + '/artifact/' + pdf_doc_artifact.relativePath) + '">PDF </a></li>' ) );
    }

    // Git
    if ( git_revision ) {
      row.find( '.col-git ul' ).append( $( '<li><a href="https://github.com/torquebox/torquebox/tree/' + git_revision + '">Tree</a></li>' ) );
      row.find( '.col-git ul' ).append( $( '<li><a href="https://github.com/torquebox/torquebox/commits/' + git_revision + '">Commits</a></li>' ) );
    }

    table.append( row );
  },

  locate_artifact: function(build, filename) {
    result = null;
    $.each( build.artifacts, function(i, artifact) { 
      if ( artifact.relativePath == filename ) {
        result = artifact;
        return false;
      }
    } );
    return result;
  },

  job_url: function(path) {
    url = this.url + '/job/' + this.job;
    if ( path ) {
      url += '/' + path;
    }
    return url;
  },
};


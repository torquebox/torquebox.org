
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
      //self.fetch_build_details( build );
      var row = $( '<tr class="build"></td>' );
  
      row_callback = null;

      if ( data.lastStableBuild.number == build.number ) {
        stable_row = row.clone();
        $('#latest-stable').append( stable_row );
        row_callback = function(data) { self.handle_build_jsonp( row, data ); self.handle_build_jsonp( stable_row, data ); }
      } else {
        row_callback = function(data) { self.handle_build_jsonp( row, data ); }
      }

      $('#builds').append( row );
      $.ajax( {
        url: build.url + '/api/json',
        jsonp: 'jsonp',
        dataType: 'jsonp',
        type: 'GET',
        context: self,
        success: row_callback,
      } );

    } );
  }, 

  handle_build_jsonp: function(row, build) {
    var self = this;
    if ( ! build ) {
      return;
    }

    if ( build.building ) {
      $('#build-currently-building').append( $( '<b>A build is currently in progress.</b>' ) );
    }

    build_result_class = "unknown";
    if ( build.result ) {
      build_result_class = 'result-' + build.result.toLowerCase();
    } else {
      if ( build.building ) {
        build_result_class = 'result-building';
      }
    }

    row.addClass( build_result_class );

    if ( build.result == 'ABORTED' ) {
      self.handle_aborted_row( row, build );
    } else {
      self.handle_typical_row( row, build );
    }
  },

  handle_aborted_row: function(row, build) {
    var self = this;
    if ( build.actions.length >= 2 ) {
      last_built_revision = build.actions[1].lastBuiltRevision;
    }

    git_revision = null;

    if ( last_built_revision ) {
      git_revision = build.actions[1].lastBuiltRevision.SHA1;
    }

    row.append( $( '<td class="col-build"></td>' ) );

    row.find( '.col-build' ).append( $( '<div class="version"><a href="' + build.url + '">' + build.number + '</div>' ) );

    row.append( $( '<td class="col-abort-details" colspan="6">Aborted</td>' ) );
  },

  handle_typical_row: function(row, build) {
    var self = this;

    if ( build.actions.length >= 2 ) {
      last_built_revision = build.actions[1].lastBuiltRevision;
    }

    git_revision = null;

    if ( last_built_revision ) {
      git_revision = build.actions[1].lastBuiltRevision.SHA1;
    }

    row.append( $( '<td class="col-build"></td>' ) );

    release_date = new Date( build.timestamp );
    formatted_time = release_date.format( "dd mmmm yyyy" ) + '<br/>' + release_date.format( "HH:MM" ) + ' US Eastern<br/>';

    if ( git_revision ) {
      short_git_revision = git_revision.substring(0, 8);
      formatted_time += '<a href="https://github.com/torquebox/torquebox/commits/' + git_revision + '">' + short_git_revision + '</a>';
    }
    row.find( '.col-build' ).append( $( '<div class="version"><a href="' + build.url + '">' + build.number + '</div>' ) );
    row.find( '.col-build' ).append( $( '<div class="release-date">' + formatted_time + '</div>' ) );

    row.append( $( '<td class="col-dist"><ul></ul></td>' ) );
    row.append( $( '<td class="col-docs"><ul></ul></td>' ) );
    row.append( $( '<td class="col-details"><ul></ul></id>' ) );
    row.append( $( '<td class="col-git"><ul></ul></td>' ) );
    

    // Dist
    if ( build.building ) {
      row.find( '.col-dist ul' ).append( $( '<li><i>Build in progress</i></li>' ) );
    }

    dist_bin_artifact = self.locate_artifact(build, 'dist/target/torquebox-dist-bin.zip' );
    if ( dist_bin_artifact ) {
      row.find( '.col-dist ul' ).append( $( '<li><a href="/builds/' +  build.number + '/torquebox-dist-bin.zip">Binary ZIP</a></li>' ) );
    }


    gem_repo_artifact = self.locate_artifact(build, 'assemblage/assembly/target/stage/gem-repo/simple-index' );
    if ( gem_repo_artifact ) {
      row.find( '.col-dist ul' ).append( $( '<li><a href="http://rubygems.torquebox.org/' +  build.number + '/">Gems Repository</a></li>' ) );
    }

    // Docs
    html_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/xhtml/index.html' );
    if ( html_doc_artifact ) {
      row.find( '.col-docs ul' ).append( $( '<li><a href="' + self.job_url( build.number + '/artifact/' + html_doc_artifact.relativePath) + '">HTML</a></li>' ) );
    }

    pdf_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/pdf/torquebox-docs-en_US.pdf' );
    if ( pdf_doc_artifact ) {
      row.find( '.col-docs ul' ).append( $( '<li><a href="' + self.job_url( build.number + '/artifact/' + pdf_doc_artifact.relativePath) + '">PDF</a></li>' ) );
    }

    if ( build.result == 'FAILURE' ) {
      if ( build.culprits.length > 0 ) {
        details_row = $( '<tr class="result-failure failure-details"/>' );
        details_row.append( $( '<td colspan="7"></td>' ).text( "Possible culprits: " + 
          $.map( build.culprits, function(each) {
            return each.fullName;
          } ).join(', ') ) );
        row.after( details_row )
      } else {
        row.addClass( 'divide' );
      }
    }

    // Details

    row.find( '.col-details ul' ).append( $( '<li><a href="' + build.url + '/changes">Changes</a></li>' ) );
    row.find( '.col-details ul' ).append( $( '<li><a href="' + build.url + '/console">Console Output</a></li>' ) );

    // Git
    if ( git_revision ) {
      row.find( '.col-git ul' ).append( $( '<li><a href="https://github.com/torquebox/torquebox/tree/' + git_revision + '">Tree</a></li>' ) );
      row.find( '.col-git ul' ).append( $( '<li><a href="https://github.com/torquebox/torquebox/commits/' + git_revision + '">Commits</a></li>' ) );
    }
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


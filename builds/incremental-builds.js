
renderer = {
  add_build: function(build) {
    var self = this;
    row = self.create_build_row( build );

    row[row.length-1].addClass( 'divide' );

    $.each( row, function(i,r) {
      $( '#builds' ).append( row[i] );
    } );
    
    if ( self.lastSuccessfulBuilder && ( self.lastSuccessfulBuild.number == build.number ) ) {
      $( '#latest-stable' ).append( row[0].clone() ); 
    }

  },

  add_matrix_build: function(build, label) {
    var self = this;
    column = $( '.build-summary.build-' + build.number ).find( 'td.' + label );
    column.removeClass( 'matrix-unknown' );

    if ( build.result == 'SUCCESS' ) {
      column.addClass( 'matrix-success' );
      column.append( 
        $( '<a href="' + build.url + '/console' + '" class="status">Passed</a>' )
      );
    } else if ( build.result == 'FAILURE' ) {
      column.addClass( 'matrix-failure' );
      column.append( 
        $( '<a href="' + build.url + '/console' + '" class="status">Failed</a>' )
      );
    }  else if ( build.result == 'ABORTED' ) {
      column.addClass( 'matrix-aborted' );
      column.append(
        $( '<a href="' + build.url + '/console' + '" class="status">Aborted</a>' )
      );
    }  else if ( build.building ) {
      column.addClass( 'matrix-building' );
      column.append(
        $( '<a href="' + build.url + '/console' + '" class="status"><em>Building</em></a>' )
      );
    }

    var duration;

    if ( build.building ) {
      duration = new Date() - new Date( build.timestamp );
    } else {
      duration = build.duration;
    }

    duration = Math.floor( duration / ( 60 * 1000 ) );

    column.append( '<span class="duration">: ' + duration + ' min</span>' );

    if ( build.building ) {
      column.append( $( '<ul class="links"/>' ).append( 
          $( '<li><a href="' + build.url + '../ws/integration-tests/target/integ-dist/jboss/server/default/log/boot.log">boot.log</a></li>'  ),
          $( '<li><a href="' + build.url + '../ws/integration-tests/target/integ-dist/jboss/server/default/log/output.log">output.log</a></li>'  ),
          $( '<li><a href="' + build.url + '../ws/integration-tests/target/integ-dist/jboss/server/default/log/server.log">server.log</a></li>'  )
        ) 
      );
    }


    if ( label == '1_8' ) {
      self.populate_artifacts( build );
    }

    row = $( '.build-' + build.number );

    if ( row.find( '.matrix' ).size() == row.find( '.matrix-success' ).size() ) {
      row.addClass( 'build-success' );
    }
    if ( row.find( '.matrix-failure' ).size() > 0 ) {
      row.addClass( 'build-failure' );
    }
    if ( row.find( '.matrix' ).size() == row.find( '.matrix-aborted' ).size() ) {
      row.addClass( 'build-aborted' );
      row.find( 'td *' ).hide();
      row.find( 'td .number' ).show();
      row.find( 'td .number a' ).show();
      $( '.build-' + build.number + '.build-details td *' ).hide();
      $( '.build-' + build.number + '.build-details' ).addClass( 'hidden' );
    }
    
  },

  populate_artifacts: function(build) {
    var self = this;

    //Binary

    binary_column = $( '.build-summary.build-' + build.number ).find( 'td.binary' );
    ul = $( '<ul/>' );

    dist_bin_artifact = self.locate_artifact(build, 'dist/target/torquebox-dist-bin.zip' );
    if ( dist_bin_artifact ) {
      ul.append( $( '<li><a href="/builds/' +  build.number + '/torquebox-dist-bin.zip">Binary ZIP</a></li>' ) );
    }

    gem_repo_artifact = self.locate_artifact(build, 'assemblage/assembly/target/stage/gem-repo/simple-index' );
    if ( gem_repo_artifact ) {
      ul.append( $( '<li><a href="http://rubygems.torquebox.org/' +  build.number + '/">Gems Repository</a></li>' ) );
    }
    binary_column.append( ul );


    // Docs
    docs_column = $( '.build-summary..build-' + build.number ).find( 'td.docs' );
    ul = $( '<ul/>' );

    html_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/xhtml/index.html' );
    if ( html_doc_artifact ) {
      ul.append( $( '<li><a href="' + build.url + '/artifact/' + html_doc_artifact.relativePath + '">HTML</a></li>' ) );
    }

    pdf_doc_artifact = self.locate_artifact(build, 'docs/en-US/target/docbook/publish/en-US/pdf/torquebox-docs-en_US.pdf' );
    if ( pdf_doc_artifact ) {
      ul.append( $( '<li><a href="' + build.url + '/artifact/' + pdf_doc_artifact.relativePath + '">PDF</a></li>' ) );
    }

    epub_doc_artifact = self.locate_artifact(build, '.repository/org/torquebox/torquebox-docs-en_US/1.0.0.CR2-SNAPSHOT/torquebox-docs-en_US-1.0.0.CR2-SNAPSHOT.epub' );
    if ( epub_doc_artifact ) {
      ul.append( $( '<li><a href="' + build.url + '/artifact/' + epub_doc_artifact.relativePath + '">ePub</a></li>' ) );
    }
    docs_column.append( ul );

  },


  create_build_row: function(build) {
    var self = this;
    row = $( '<tr class="build-summary build-' + build.number + '"/>' ).append(
            $( '<td class="build-info first"/>' ).append(
              $( '<span class="number"><a href="' + build.url + '">' + build.number + '</a></span>' ),
              $( '<span class="date">' + self.build_date( build ) + '</span>' ),
              $( '<span class="time">' + self.build_time( build ) + '</span>' )
            ),
            $( '<td class="binary"/>' ),
            $( '<td class="docs"/>' ),
            $( '<td class="git"/>' ),
            $( '<td rowspan="2" class="matrix 1_8 matrix-unknown"/>' ),
            $( '<td rowspan="2" class="matrix 1_9 matrix-unknown"/>' )
          );

    if ( self.build_sha1( build ) ) {
      row.find( '.build-info' ).append(          
        $( '<span class="sha1"/>' ).append( 
          $('<a href="https://github.com/torquebox/torquebox/commits/' + self.build_sha1( build )+ '">' + self.build_sha1_short( build ) + '</a>' )
        )
      );
      row.find( '.git').append(
        $( '<ul/>' ).append(
          $( '<li/>').append(
            $( '<a href="https://github.com/torquebox/torquebox/commits/' + self.build_sha1( build ) + '">Commits</a>' )
          ),
          $( '<li/>').append(
            $( '<a href="https://github.com/torquebox/torquebox/tree/' + self.build_sha1( build )+ '">Tree</a>' )
          )
        )
      );
    }

    details_row = $( '<tr class="build-details build-' + build.number + '"/>' ).append( 
      $( '<td class="first" colspan="4"/>' )
    );

    if ( build.result == 'FAILURE' ) {
      if ( build.culprits.length > 0 ) {
        names = $.map( build.culprits, function(each,i) {
          return each.fullName;
        } );
        details_row.find( 'td' ).append( "Possible culprits: " + names.join( ', ' ) );
      }
    }

    if ( build.building ) {
      row.addClass( 'build-building' );
      details_row.addClass( 'build-building' );
      $('#build-currently-building').append( $( '<b>A build is currently in progress.</b>' ) );
    }

    return [ row, details_row ];
  },

  build_date: function(build) {
     date = new Date( build.timestamp );
     return date.format( "dd mmmm yyyy" );
  },

  build_time: function(build) {
     date = new Date( build.timestamp );
     return date.format( "HH:MM" ) + ' US Eastern';
  },

  build_sha1: function(build) {
    if ( build.actions && build.actions.length >= 2 ) {
      return build.actions[1].lastBuiltRevision.SHA1;
    }
    return null;
  },

  build_sha1_short: function(build) {
    if ( build.actions && build.actions.length >= 2 ) {
      return build.actions[1].lastBuiltRevision.SHA1.substring(0,8);
    }
    return null;
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

};

j = new Jenkins( renderer, 'http://torquebox.ci.cloudbees.com', 'torquebox', [
                   [ 'label=m1.large,ruby_compat_version=1.8', '1_8' ],
                   [ 'label=m1.large,ruby_compat_version=1.9', '1_9' ],
                 ] );

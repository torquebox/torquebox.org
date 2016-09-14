
renderer = {
  add_build: function(build) {
    var self = this;
    row = self.create_build_row( build );

    row[row.length-1].addClass( 'divide' );

    $.each( row, function(i,r) {
      $( '#builds' ).append( row[i] );
    } );

    if ( self.lastSuccessfulBuild && ( self.lastSuccessfulBuild.number == build.number ) ) {
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
          $( '<li><a href="' + build.url + '../ws/integration-tests/target/integ-dist/jboss/standalone/log/boot.log">boot.log</a></li>'  ),
          $( '<li><a href="' + build.url + '../ws/integration-tests/target/integ-dist/jboss/standalone/log/server.log">server.log</a></li>'  )
        )
      );
    }


    if ( label == '1_9' ) {
      self.populate_artifacts( build );
      self.update_artifacts( build );
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

    if ( build.result != 'SUCCESS' ) {
      return;
    }

    //Binary

    binary_column = $( '.build-summary.build-' + build.number ).find( 'td.binary' );
    ul = $( '<ul/>' );
    ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/torquebox-dist-bin.zip">Binary ZIP</a></li>' ) );
    ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/gem-repo/">Gems Repository</a></li>' ) );
    binary_column.append( ul );

    // Docs

    docs_column = $( '.build-summary.build-' + build.number ).find( 'td.docs' );
    ul = $( '<ul/>' );
    ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/html-docs/">Browse HTML</a></li>' ) );
    ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/torquebox-docs.pdf">PDF</a></li>' ) );
    ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/torquebox-docs.epub">ePub</a></li>' ) );
    if (build.number >= 1188) {
      ul.append( $( '<li class="artifact"><a href="/builds/' + build.number + '/getting-started/">Getting Started Guide</a></li>') );
    }
    ul.append( $( '<li class="artifact newdocs"><a href="/builds/' + build.number + '/javadocs/">Java API Docs</a></li>' ) );
    ul.append( $( '<li class="artifact newdocs"><a href="/builds/' + build.number + '/yardocs/">Gem RDocs</a></li>' ) );

    docs_column.append( ul );

  },


  update_artifacts: function(build) {
    if ( build.result != 'SUCCESS' ) {
      return;
    }

    $( '.build-summary.build-' + build.number ).find( 'li.artifact.newdocs' ).hide();

    $.get( '/builds/' + build.number + '/published-artifacts.json',
           function(data) {
               $( '.build-summary.build-' + build.number ).find( 'li.artifact' ).each( function(idx, li) {
                   href = $( li ).find( 'a' ).attr( 'href' );
                   artifact_name = href.match( new RegExp( "/([^/]*)/?$" ) )[1];
                   for(i=0; i < data.length; i++) {
                       url = data[i]
                       if (url.match( new RegExp( artifact_name ) )) {
                           $( li ).show();
                           return;
                       }
                   }
                   $( li ).hide();
               } );
           },
         'json' );
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
            $( '<td class="git"/>' )
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
      row.addClass( 'build-failure' );
      details_row.addClass( 'build-failure' );
      if ( build.culprits.length > 0 ) {
        names = $.map( build.culprits, function(each,i) {
          return each.fullName;
        } );
        details_row.find( 'td' ).append( "Possible culprits: " + names.join( ', ' ) );
      }
    } else if ( build.result == 'SUCCESS' ) {
      row.addClass( 'build-success' );
      details_row.addClass( 'build-success' );
    } else if ( build.result == 'ABORTED' ) {
      row.addClass( 'build-aborted' );
      details_row.addClass( 'build-aborted' );
      row.find( 'td *' ).hide();
      row.find( 'td .number' ).show();
      row.find( 'td .number a' ).show();
      $( '.build-' + build.number + '.build-details td *' ).hide();
      $( '.build-' + build.number + '.build-details' ).addClass( 'hidden' );
    }

    self.populate_artifacts( build );
    self.update_artifacts( build );

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
    if (build.actions) {
      return build.actions.reduce(function(found, action) {
        if (!found && action.lastBuiltRevision) {
          return action.lastBuiltRevision.SHA1
        } else {
          return found
        }
      }, null)
    }
    return null;
  },

  build_sha1_short: function(build) {
    var sha = this.build_sha1(build)
    if (sha) {
      return sha.substring(0,8);
    }
    return null;
  },

  locate_artifact: function(build, filename) {
    result = null;
    var filename_regexp = new RegExp( filename );
    $.each( build.artifacts, function(i, artifact) {
      if ( artifact.relativePath.match( filename_regexp )  ) {
        result = artifact;
        return false;
      }
    } );
    return result;
  }

};

j = new Jenkins( renderer, 'http://projectodd.ci.cloudbees.com', 'torquebox-incremental', [] );


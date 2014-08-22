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

    self.add_build_details(build);

  },

  add_build_details: function(build) {
    var self = this;
    row = $( '.build-' + build.number );
    column = $( '.build-summary.build-' + build.number ).find( 'td.status4x' );

    if ( build.result == 'SUCCESS' ) {
      row.addClass( 'build-success' );
      column.append(
        $( '<a href="' + build.url + 'console' + '" class="status">Passed</a>' )
      );
    } else if ( build.result == 'FAILURE' ) {
      row.addClass( 'build-failure' );
      column.append(
        $( '<a href="' + build.url + 'console' + '" class="status">Failed</a>' )
      );
    }  else if ( build.result == 'ABORTED' ) {
      row.addClass( 'build-aborted' );
      row.find( 'td *' ).hide();
      row.find( 'td .number' ).show();
      row.find( 'td .number a' ).show();
      $( '.build-' + build.number + '.build-details td *' ).hide();
      $( '.build-' + build.number + '.build-details' ).addClass( 'hidden' );
      column.append(
        $( '<a href="' + build.url + 'console' + '" class="status">Aborted</a>' )
      );
    }  else if ( build.building ) {
      column.append(
        $( '<a href="' + build.url + 'console' + '" class="status"><em>Building</em></a>' )
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

    self.populate_artifacts( build );
  },

  populate_artifacts: function(build) {
    var self = this;

    if ( build.result != 'SUCCESS' ) {
      return;
    }

    // Docs
    if (build.number >= 170) {
      docs_column = $( '.build-summary.build-' + build.number ).find( 'td.docs4x' );
      docs_column.append( $( '<a href="/4x/builds/' + build.number + '/docs/">Browse API</a>' ) );
    }

  },

  create_build_row: function(build) {
    var self = this;
    row = $( '<tr class="build-summary build-' + build.number + '"/>' ).append(
            $( '<td class="build-info first"/>' ).append(
              $( '<span class="number"><a href="' + build.url + '">' + build.number + '</a></span>' ),
              $( '<span class="date">' + self.build_date( build ) + ' ' + self.build_time( build ) + '</span>' )
            ),
            $( '<td class="docs4x"/>' ),
            $( '<td class="git4x"/>' ),
            $( '<td rowspan="2" class="status4x 1_9"/>' )
          );

    if ( self.build_sha1( build ) ) {
      row.find( '.git4x').append(
        self.build_sha1_short( build ), ': ',
        $( '<a href="https://github.com/torquebox/torquebox/commits/' + self.build_sha1( build ) + '">Commits</a>' ),
        ' / ',
        $( '<a href="https://github.com/torquebox/torquebox/tree/' + self.build_sha1( build )+ '">Tree</a>' )
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

j = new Jenkins( renderer, 'https://projectodd.ci.cloudbees.com', 'torquebox-4',
                 [] );

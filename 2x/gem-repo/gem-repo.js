
$(document).ready(function() {
  var handle_job_jsonp = function(data) {
    $( '#build_header' ).text( "Build " + data.number ); 
    var gem_regexp = new RegExp( '^(.*).gem$' );
    $.each( data.artifacts, function(i, artifact) {
      if ( gem_regexp.exec( artifact.fileName ) ) {
        $( '#gems' ).append( 
          $( '<tr/>' ).append( 
            $( '<td/>' ).append(
              $( '<a href="./gems/' + artifact.fileName + '"/>' ).append(
                artifact.fileName
              )
            )
          )
        );
      }
    } );
  };

  regexp = new RegExp( "^/2x/gem-repo/([0-9]+)/?$" );

  match = regexp.exec( window.location.pathname );

  var effective_version = "lastSuccessfulBuild";
  if ( match ) {
    effective_version = match[1];
  }

  $.ajax( { 
    url: 'https://torquebox.ci.cloudbees.com/job/torquebox-2x/label=m1.large,ruby_compat_version=1.8/' + effective_version + '/api/json?depth=1',
    jsonp: 'jsonp',
    dataType: 'jsonp',
    type: 'GET',
    context: self,
    async: false,
    success: handle_job_jsonp,
  } );

});


function Jenkins(renderer, url, job, matrix) {
  this.renderer = renderer;
  this.url = url;
  this.job = job;
  this.builds = {} ;
  this.root_data = {};
  this.matrix = matrix;
  this.initialize();
}

Jenkins.prototype = {
  initialize: function() {
    var self = this;
    $.ajax( { 
      url: self.job_url('api/json?depth=1' ),
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
    self.primary_data = data;
    self.renderer.lastSuccessfulBuild = self.primary_data.lastSuccessfulBuild;
    $.each( self.primary_data.builds, function(i, build) {
      self.renderer.add_build( build );
    } );

    $.each( self.matrix, function(i, matrix_leg ) {
      $.ajax( { 
        url: self.job_url( '/' + matrix_leg[0] + '/api/json?depth=1' ),
        jsonp: 'jsonp',
        dataType: 'jsonp',
        type: 'GET',
        context: self,
        async: false,
        success: self.handle_matrix_leg_jsonp,
      } );
    } );
  },

  handle_matrix_leg_jsonp: function(data) {
    var self = this;

    var label = '';
    $.each( self.matrix, function(i,matrix_leg) {
      if ( matrix_leg[0] == data.name ) {
        label = matrix_leg[1];
      }
    } );

    $.each( data.builds, function(i, build) {
      self.renderer.add_matrix_build( build, label );
    } );
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

}

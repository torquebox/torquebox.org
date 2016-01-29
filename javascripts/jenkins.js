
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
      url: self.job_url('api/json?tree=builds[*[*[*]]],lastSuccessfulBuild[*[*[*]]]' ),
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

    $.each(data.builds, function(i, build) {
      $.each(build.runs || [], function(i, run) {
        if (run.number == build.number) {
          self.handle_matrix_leg(run);
        }
      });
    });
  },

  handle_matrix_leg: function(data) {
    var self = this;

    var label = '';
    $.each(self.matrix, function(i,matrix_leg) {
      if (data.url.indexOf(matrix_leg[0]) >= 0) {
        label = matrix_leg[1];
      }
    });

    self.renderer.add_matrix_build(data, label);
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

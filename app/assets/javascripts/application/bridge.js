var mumuki = mumuki || {};
(function (mumuki) {

  function Laboratory(exerciseId){
    this.exerciseId = exerciseId;
  }

  Laboratory.prototype = {
    runLocalTests: function (solution) {
      var token = new mumuki.CsrfToken();
      var request = token.newRequest({
        type: 'POST',
        url: window.location.origin + window.location.pathname + '/solutions',
        data: solution
      });
      return $.ajax(request)
    },
    runTests: function(content) {
      return this.runLocalTests({ solution: content });
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));

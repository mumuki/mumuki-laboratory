var mumuki = mumuki || {};
(function (mumuki) {

  function Laboratory(exerciseId){
    this.exerciseId = exerciseId;
  }

  Laboratory.prototype = {
    runTests: function (solution) {
      var token = new mumuki.CsrfToken();
      var request = token.newRequest({
        type: 'POST',
        url: window.location + '/solutions',
        data: solution
      });
      return $.ajax(request)
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));

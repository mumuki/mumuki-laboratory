var mumuki = mumuki || {};
(function (mumuki) {

  function Laboratory(exerciseId){
    this.exerciseId = exerciseId;
  }

  Laboratory.prototype = {
    runTests: function (content) {
      return $.ajax({
        type: 'POST',
        url: window.location + '/solutions',
        data: {
          solution: {
            content: content
          }
        }
      })
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));

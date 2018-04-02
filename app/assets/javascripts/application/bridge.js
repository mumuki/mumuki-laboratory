var mumuki = mumuki || {};
(function (mumuki) {

  function Laboratory(exerciseId){
    this.exerciseId = exerciseId;
  }

  Laboratory.prototype = {
    runTests: function (solution) {
      return $.ajax({
        type: 'POST',
        url: window.location + '/solutions',
        data: {
          solution: solution
        }
      })
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));

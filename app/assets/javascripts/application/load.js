var mumuki = mumuki || {};

(function (mumuki) {
  mumuki.load = function (callback) {
    $(document).on('turbolinks:load', callback);
  };
})(mumuki);

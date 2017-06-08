mumuki.load(function() {
  $('#upload').change(function (evt) {
    var file = evt.target.files[0];
    if (!file) return;

    var reader = new FileReader();
    reader.onload = function (e) {
      var contents = e.target.result;
      $('#solution_content').attr('value', contents);
      $(evt.target).val("");
      $('form').submit();
    };
    reader.readAsText(file);
    return false;
  });
});


mumuki.load(() => {
  $('#upload-input').change(function (evt) {
    var file = evt.target.files[0];
    if (!file) return;

    var reader = new FileReader();
    reader.onload = function (e) {
      var contents = e.target.result;
      $('#solution_content').html(contents);
      $(evt.target).val("");
      $('form.new_solution').submit();
    };
    reader.readAsText(file);
    return false;
  });
});


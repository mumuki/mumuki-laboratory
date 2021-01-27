mumuki.load(() => {
  $('#upload-input').change(function (evt) {
    var file = evt.target.files[0];
    if (!file) return;

    $('.btn-submit').removeClass('disabled');

    var reader = new FileReader();
    reader.onload = function (e) {
      var contents = e.target.result;
      $('#solution_content').html(contents);
      $(evt.target).val("");
    };
    reader.readAsText(file);
  });
});


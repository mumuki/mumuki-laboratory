$(document).on('ready page:load', function () {
  $('#upload').change(function (evt) {
      console.log('changed')
      var file = evt.target.files[0];
      if (!file) return;

      var reader = new FileReader();
      reader.onload = function (e) {
        var contents = e.target.result;
        $('#solution_content').attr('value', contents);
        $('form').submit();
        $(evt.target).val("");
      };
      reader.readAsText(file);
    }
  );
})

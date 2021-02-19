mumuki.load(() => {
  let $uploadInput = $('#mu-upload-input');
  let maxFileSize = $uploadInput.attr("mu-upload-file-limit");
  let $uploadFileLimitExceeded = $('#mu-upload-file-limit-exceeded');
  let $uploadLabel = $('#mu-upload-label span');
  let $uploadLabelText = $uploadLabel.text();
  let $uploadIcon = $('#mu-upload-icon');
  let $btnSubmit = $('.btn-submit');

  $uploadInput.change(function (evt) {
    var file = evt.target.files[0];
    if (!file) return;

    if (file.size > maxFileSize) {
      showFileExceedsMaxSize();
      return;
    }

    allowSubmissionFor(file.name);

    var reader = new FileReader();
    reader.onload = function (e) {
      var contents = e.target.result;
      $('#solution_content').html(contents);
      $(evt.target).val("");
    };
    reader.readAsText(file);
  });

  function showFileExceedsMaxSize() {
    $uploadFileLimitExceeded.removeClass('hidden');
    $uploadLabel.text($uploadLabelText);
    $uploadIcon.addClass('fa-upload').removeClass('fa-file-alt');
    $btnSubmit.addClass('disabled');
  }

  function allowSubmissionFor(filename) {
    $uploadFileLimitExceeded.addClass('hidden');
    $uploadLabel.text(filename);
    $uploadIcon.removeClass('fa-upload').addClass('fa-file-alt');
    $btnSubmit.removeClass('disabled');
  }
});


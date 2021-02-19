mumuki.upload = (() => {
  class FileUploader {
    constructor(file) {
      this.file = file;

      this.$uploadFileLimitExceeded = $('#mu-upload-file-limit-exceeded');
      this.$uploadLabel = $('#mu-upload-label span');
      this.$uploadLabelText = this.$uploadLabel.text();
      this.$uploadIcon = $('#mu-upload-icon');
      this.$btnSubmit = $('.btn-submit');
    }

    uploadFileIfValid() {
      if (!this.file) return;

      let maxFileSize = $('#mu-upload-input').attr("mu-upload-file-limit");
      if (this.file.size > maxFileSize) {
        return this.showFileExceedsMaxSize();
      }

      this.allowSubmissionFor(this.file.name);

      var reader = new FileReader();
      reader.onload = function (e) {
        var contents = e.target.result;
        $('#solution_content').html(contents);
      };
      reader.readAsText(this.file);
    }

    showFileExceedsMaxSize() {
      this.$uploadFileLimitExceeded.removeClass('hidden');
      this.$uploadLabel.text(this.$uploadLabelText);
      this.$uploadIcon.addClass('fa-upload').removeClass('fa-file-alt');
      this.$btnSubmit.addClass('disabled');
    }

    allowSubmissionFor(filename) {
      this.$uploadFileLimitExceeded.addClass('hidden');
      this.$uploadLabel.text(filename);
      this.$uploadIcon.removeClass('fa-upload').addClass('fa-file-alt');
      this.$btnSubmit.removeClass('disabled');
    }
  }

  return {
    FileUploader
  };
})();

mumuki.load(() => {
  $('#mu-upload-input').change(function (evt) {
    return new mumuki.upload.FileUploader(evt.target.files[0]).uploadFileIfValid();
  });
});


mumuki.upload = (() => {
  class FileUploader {
    constructor(file) {
      this.file = file;
    }

    uploadFileIfValid() {
      if (!this.file) return;

      let maxFileSize = $('#mu-upload-input').attr("mu-upload-file-limit");
      if (this.file.size > maxFileSize) {
        return mumuki.upload.ui.showFileExceedsMaxSize();
      }

      mumuki.upload.ui.allowSubmissionFor(this.file.name);

      const reader = new FileReader();
      reader.onload = function (e) {
        const contents = e.target.result;
        $('#solution_content').html(contents);
      };
      reader.readAsText(this.file);

      return reader;
    }
  }

  class UI {
    constructor() {
      this.$uploadFileLimitExceeded = $('#mu-upload-file-limit-exceeded');
      this.$uploadLabel = $('#mu-upload-label span');
      this.$uploadLabelText = this.$uploadLabel.text();
      this.$uploadIcon = $('#mu-upload-icon');
      this.$btnSubmit = $('.btn-submit');
    }

    showFileExceedsMaxSize() {
      this.$uploadFileLimitExceeded.removeClass('d-none');
      this.$uploadLabel.text(this.$uploadLabelText);
      this.$uploadIcon.addClass('fa-upload').removeClass('fa-file-alt');
      this.$btnSubmit.addClass('disabled');
    }

    allowSubmissionFor(filename) {
      this.$uploadFileLimitExceeded.addClass('d-none');
      this.$uploadLabel.text(filename);
      this.$uploadIcon.removeClass('fa-upload').addClass('fa-file-alt');
      this.$btnSubmit.removeClass('disabled');
    }
  }

  function _setUI() {
    mumuki.upload.ui = new UI();
  }

  return {
    FileUploader,
    UI,

    _setUI,

    /** @type {UI} */
    ui: null
  };
})();

mumuki.load(() => {
  $('#mu-upload-input').change(function (evt) {
    if (!mumuki.upload.ui) mumuki.upload._setUI();
    return new mumuki.upload.FileUploader(evt.target.files[0]).uploadFileIfValid();
  });
});

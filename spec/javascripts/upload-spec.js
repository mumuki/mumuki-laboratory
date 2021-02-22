describe('upload', () => {
  const fileSizeLimit = 20;

  fixture.set(`
    <textarea id="solution_content" type="text" name="solution[content]" class="hidden"></textarea>
    <input id="mu-upload-input" type="file" class="upload submission-control hidden" mu-upload-file-limit=${fileSizeLimit} accept=".txt" />
    <label id="mu-upload-label" for="mu-upload-input" class="btn btn-success"></label>
    <button class="btn btn-success btn-block btn-submit disabled"></button>
    <div id="mu-upload-file-limit-exceeded" class="hidden"></div>
  `);

  describe('no file is uploaded', () => {
    beforeEach(() => {
      mumuki.upload._setUI();
      new mumuki.upload.FileUploader(null).uploadFileIfValid();
    });

    it('does not allow submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(true);
    });

    it('does not exceed max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('hidden')).toBe(true);
    });
  });

  describe('small file is uploaded', () => {
    beforeEach(() => {
      mumuki.upload._setUI();
      new mumuki.upload.FileUploader(new File(["short solution"], "short.txt")).uploadFileIfValid();
    });

    it('allows submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(false);
    });

    it('does not exceed max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('hidden')).toBe(true);
    });
   });

  describe('large file is uploaded', () => {
    beforeEach(() => {
      mumuki.upload._setUI();
      new mumuki.upload.FileUploader(new File(["solution that is too long to be allowed"], "long.txt")).uploadFileIfValid();
    });

    it('does not allow submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(true);
    });

    it('exceeds max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('hidden')).toBe(false);
    });
  });
});

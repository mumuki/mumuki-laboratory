describe('upload', () => {
  const fileSizeLimit = 20;

  fixture.set(`
    <textarea id="solution_content" type="text" name="solution[content]" class="d-none"></textarea>
    <input id="mu-upload-input" type="file" class="upload submission-control d-none" mu-upload-file-limit=${fileSizeLimit} accept=".txt" />
    <label id="mu-upload-label" for="mu-upload-input" class="btn btn-success"></label>
    <button class="btn btn-success btn-block btn-submit disabled"></button>
    <div id="mu-upload-file-limit-exceeded" class="d-none"></div>
  `);

  beforeEach(() => {
    mumuki.upload._setUI();
  });

  function reader(file, done) {
    let fileReader = new mumuki.upload.FileUploader(file).uploadFileIfValid();
    if (fileReader) {
      fileReader.addEventListener('load', () => done());
      fileReader.addEventListener('error', done);
      return fileReader;
    } else {
      done();
    }
  }

  describe('no file is uploaded', () => {
    beforeEach((done) => {
      reader(null, done);
    });

    it('loads no solution', function () {
      expect($('#solution_content').html()).toEqual('');
    });

    it('does not allow submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(true);
    });

    it('does not exceed max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('d-none')).toBe(true);
    });
  });

  describe('small file is uploaded', () => {
    beforeEach((done) => {
      reader(new File(["short solution"], "short.txt"), done);
    });

    it('loads solution', function () {
      expect($('#solution_content').html()).toEqual('short solution');
    });

    it('allows submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(false);
    });

    it('does not exceed max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('d-none')).toBe(true);
    });
  });

  describe('large file is uploaded', () => {
    beforeEach((done) => {
      reader(new File(["solution that is too long to be allowed"], "long.txt"), done);
    });

    it('loads no solution', function () {
      expect($('#solution_content').html()).toEqual('');
    });

    it('does not allow submitting', function () {
      expect($('.btn-submit').hasClass('disabled')).toBe(true);
    });

    it('exceeds max file size', function () {
      expect($('#mu-upload-file-limit-exceeded').hasClass('d-none')).toBe(false);
    });
  });
});

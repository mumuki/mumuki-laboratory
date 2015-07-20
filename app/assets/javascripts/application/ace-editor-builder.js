function AceEditorBuilder(textarea) {
  this.textarea = textarea;
}
AceEditorBuilder.prototype = {
  setupEditor: function() {
    this.form = this.textarea.form;
    this.editor = ace.edit(this.textarea);
    this.editor.container.id = "editor-container";//FIXME

  },
  setupLanguage: function () {
    var language = $(this.textarea).data('editor-language');
    if (language === 'dynamic') {
      dynamicEditors.push(this.editor);
    } else {
      setEditorLanguage(this.editor, language);
    }
  },
  setupOptions: function () {
    this.editor.setOptions({
      minLines: 15,
      maxLines: Infinity,
      wrap: true
    });
    this.editor.setFontSize(13);
  },
  setupSubmit: function () {
    var textarea = this.textarea;
    var form = this.form;
    var editor = this.editor;
    this.form.addEventListener("submit", function () {
      textarea.style.visibility = "hidden";//FIXME
      textarea.value = editor.getValue();
      form.appendChild(textarea)
    });
  },
  build: function () {
    return this.editor;
  }
};

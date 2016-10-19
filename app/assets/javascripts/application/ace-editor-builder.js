var mumuki = mumuki || {};

(function (mumuki) {

  function AceEditorBuilder(textarea) {
    this.textarea = textarea;
  }

  AceEditorBuilder.prototype = {
    setupEditor: function () {
      this.form = this.textarea.form;
      this.editor = ace.edit(this.textarea);
      this.editor.container.id = "editor-container";
    },
    setupLanguage: function () {
      var language = $(this.textarea).data('editor-language');
      if (language === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        mumuki.editor.setEditorLanguage(this.editor, language);
      }
    },
    setupOptions: function (minLines) {
      this.editor.setOptions({
        maxLines: Infinity,
        showPrintMargin: false,
        selectionStyle: 'text',
        minLines: minLines,
        showGutter: minLines > 1,
        cursorStyle: minLines > 1 ? 'ace' : 'slim',
        highlightActiveLine: minLines > 1,
        wrap: true
      });
      this.editor.setFontSize(17);
    },
    setupSubmit: function () {
      var textarea = this.textarea;
      var form = this.form;
      var editor = this.editor;
      this.form.addEventListener("submit", function () {
        textarea.style.visibility = "hidden";
        textarea.value = editor.getValue();
        form.appendChild(textarea)
      });
    },
    build: function () {
      return this.editor;
    }
  };

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.AceEditorBuilder = AceEditorBuilder;
})(mumuki);

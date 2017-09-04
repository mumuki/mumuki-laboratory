var mumuki = mumuki || {};

(function (mumuki) {

  function CodeMirrorBuilder(textarea) {
    this.textarea = textarea;
    this.$textarea = $(textarea);
  }

  CodeMirrorBuilder.prototype = {
    setupEditor: function () {
      this.editor = CodeMirror.fromTextArea(this.textarea, {
          tabSize: 2,
          lineNumbers: true,
          lineWrapping: true,
          cursorHeight: 1,
          lineWiseCopyCut: true,
          showCursorWhenSelecting: true
      });
    },
    setupLanguage: function () {
      var language = this.$textarea.data('editor-language');
      if (language === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        mumuki.editor.setOption('mode', language);
      }
    },
    setupOptions: function (minLines) {
      this.editor.setOption('minLines', minLines);
    },
    build: function () {
      return this.editor;
    }
  };

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.CodeMirrorBuilder = CodeMirrorBuilder;
}(mumuki));

var mumuki = mumuki || {};

(function (mumuki) {

  function CodeMirrorBuilder(textarea) {
    this.textarea = textarea;
    this.$textarea = $(textarea);
  }

  CodeMirrorBuilder.prototype = {
    setupEditor: function () {
      this.editor = CodeMirror.fromTextArea(this.textarea);
    },
    setupLanguage: function () {
      var language = $(this.textarea).data('editor-language');
      if (language === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        mumuki.editor.setOption('mode', language);
      }
    },
    setupPlaceholder: function (text) {
      this.editor.setOption('placeholder', text);
    },

    setupOptions: function (minLines) {
      this.editor.setOption('tabSize', 2);
      this.editor.setOption('indentWithTabs', true);
      this.editor.setOption('lineWrapping', true);
      this.editor.setOption('lineNumbers', true);
      this.editor.setOption('showCursorWhenSelecting', true);
      this.editor.setOption('lineWiseCopyCut', true);
      this.editor.setOption('cursorHeight', 1);
    },
    build: function () {
      return this.editor;
    }
  };

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.CodeMirrorBuilder = CodeMirrorBuilder;
}(mumuki));

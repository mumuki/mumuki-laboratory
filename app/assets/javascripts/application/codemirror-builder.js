var mumuki = mumuki || {};

(function (mumuki) {

  function CodeMirrorBuilder(textarea) {
    this.textarea = textarea;
    this.$textarea = $(textarea);
  }

  function submit() {
    $('body').removeClass('fullscreen');
    $('.editor-resize .fa-stack-1x').removeClass('fa-compress').addClass('fa-expand');
    $('.btn-submit').click();
  }

  function submitMessage() {
    $('.discussion-new-message-button').click();
  }

  var codeMirrorDefaults = {
    autofocus: false,
    tabSize: 2,
    cursorHeight: 1,
    matchBrackets: true,
    lineWiseCopyCut: true,
    autoCloseBrackets: true,
    showCursorWhenSelecting: true,
    lineWrapping: true
  };

  CodeMirrorBuilder.prototype = {
    createEditor: function (customOptions) {
      return CodeMirror.fromTextArea(this.textarea, Object.assign({}, codeMirrorDefaults, customOptions));
    },
    setupEditor: function () {
      this.editor = this.createEditor({
        lineNumbers: true,
        extraKeys: {
          'Ctrl-Space': 'autocomplete',
          'Cmd-Enter': submit,
          'Ctrl-Enter': submit,
          'F11': function () {
            mumuki.editor.toggleFullscreen();
          },
          'Tab': function (cm) {
            mumuki.editor.indentWithSpaces(cm)
          }
        }
      });
    },
    setupSimpleEditor: function () {
      this.editor = this.createEditor({
        mode: 'text',
        extraKeys: {
          'Cmd-Enter': submitMessage,
          'Ctrl-Enter': submitMessage,
          'Tab': function (cm) {
            mumuki.editor.indentWithSpaces(cm)
          }
        }
      });
    },
    setupLanguage: function () {
      var language = this.$textarea.data('editor-language');
      if (language === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        this.editor.setOption('mode', language);
        this.editor.refresh();
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

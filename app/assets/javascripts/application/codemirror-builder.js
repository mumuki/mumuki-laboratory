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
    lineWrapping: true,
    autoRefresh: true
  };

  CodeMirrorBuilder.prototype = {
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

      return this;
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

      return this;
    },
    setupReadOnlyEditor: function () {
      this.editor = this.createEditor({
        readOnly: true,
        cursorBlinkRate: -1, //Hides the cursor
        lineNumbers: true
      });

      return this;
    },
    setupLanguage: function (language) {
      var highlightMode = language || this.$textarea.data('editor-language');
      if (highlightMode === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        this.editor.setOption('mode', highlightMode);
        this.editor.refresh();
      }

      return this;
    },
    setupMinLines: function (minLines) {
      this.editor.setOption('minLines', minLines);

      return this;
    },
    build: function () {
      return this.editor;
    },
    createEditor: function (customOptions) {
      return CodeMirror.fromTextArea(this.textarea, Object.assign({}, codeMirrorDefaults, customOptions));
    }
  };

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.CodeMirrorBuilder = CodeMirrorBuilder;
}(mumuki));

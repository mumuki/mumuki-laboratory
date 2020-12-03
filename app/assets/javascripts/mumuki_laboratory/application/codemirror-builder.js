(() => {
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

  class CodeMirrorBuilder {
    constructor(textarea) {
      this.textarea = textarea;
      this.$textarea = $(textarea);
    }

    setupEditor() {
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
            mumuki.editor.indentWithSpaces(cm);
          }
        }
      });

      return this;
    }

    setupSimpleEditor() {
      this.editor = this.createEditor({
        mode: 'text',
        extraKeys: {
          'Cmd-Enter': submitMessage,
          'Ctrl-Enter': submitMessage,
          'Tab': function (cm) {
            mumuki.editor.indentWithSpaces(cm);
          }
        }
      });

      return this;
    }

    setupReadOnlyEditor() {
      this.editor = this.createEditor({
        readOnly: true,
        cursorBlinkRate: -1, //Hides the cursor
        lineNumbers: true
      });

      return this;
    }

    setupLanguage(language) {
      var highlightMode = language || this.$textarea.data('editor-language');
      if (highlightMode === 'dynamic') {
        mumuki.page.dynamicEditors.push(this.editor);
      } else {
        this.editor.setOption('mode', highlightMode);
        this.editor.refresh();
      }

      return this;
    }

    setupMinLines(minLines) {
      this.editor.setOption('minLines', minLines);

      return this;
    }

    build() {
      return this.editor;
    }

    createEditor(customOptions) {
      return CodeMirror.fromTextArea(this.textarea, Object.assign({}, codeMirrorDefaults, customOptions));
    }
  }

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.CodeMirrorBuilder = CodeMirrorBuilder;
})();

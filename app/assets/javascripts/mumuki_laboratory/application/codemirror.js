(() => {
  function createCodeMirrors() {
    return $(".editor").map(function (index, textarea) {
      var $textarea = $("#solution_content");

      return new mumuki.editor.CodeMirrorBuilder(textarea)
        .setupEditor()
        .setupMinLines($textarea.data('lines'))
        .setupLanguage()
        .build();
    });
  }

  function onSelectUpdateCodeMirror() {
    $("#exercise_language_id").change(updateCodeMirrorLanguage);
  }

  function resetEditor() {
    mumuki.page.dynamicEditors.forEach(function (e) {
      setDefaultContent(e, $('#default_content').val());
    })
  }

  function formatContent() {
    mumuki.page.editors.each(function (_, editor) {
      editor.setSelection({line: 0, ch: 0}, {line: editor.lineCount()})
      editor.indentSelection("smart")
      editor.setSelection({line: 0})
    });
  }

  function toggleFullscreen() {
    $('body').toggleClass('fullscreen');
    $('.editor-resize .fa-stack-1x').toggleClass('fa-expand').toggleClass('fa-compress');
  }

  function indentWithSpaces(cm) {
    if (cm.somethingSelected()) {
      cm.indentSelection("add");
    } else {
      cm.execCommand("insertSoftTab");
    }
  }

  function setDefaultContent(editor, content) {
    editor.getDoc().setValue(content);
  }

  function updateCodeMirrorLanguage() {
    var language = $("#exercise_language_id").find(":selected").html() || $('#exercise_language').val();
    if (language !== undefined) {
      mumuki.page.dynamicEditors.forEach(function (e) {
        setEditorLanguage(e, language);
      })
    }
  }

  function setEditorLanguage(editor, language) {
    editor.setOption("mode", language);
    editor.setOption('theme', 'default ' + language);
  }

  function syncContent(){
    mumuki.page.editors.each(function (_, editor) {
      editor.save();
    });
  }

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.reset = resetEditor;
  mumuki.editor.toggleFullscreen = toggleFullscreen;
  mumuki.editor.formatContent = formatContent;
  mumuki.editor.indentWithSpaces = indentWithSpaces;
  mumuki.editor.syncContent = syncContent;

  mumuki.page = mumuki.page || {};
  mumuki.page.dynamicEditors = [];
  mumuki.page.editors = [];


  mumuki.load(function () {
    mumuki.page.editors = createCodeMirrors();
    mumuki.editors.registerContentSyncer(mumuki.editor.syncContent);
    updateCodeMirrorLanguage();
    onSelectUpdateCodeMirror();

    $('.editor-reset').click(function (event) {
      event.stopPropagation();
      const selection = confirm(this.getAttribute('data-confirm'));
      if(selection) resetEditor();
    });

    $('.editor-resize').click(function () {
      toggleFullscreen();
    });

    $('.editor-format').click(function (){
      formatContent();
    });
  });

})();

var mumuki = mumuki || {};

(function (mumuki) {
  function createCodeMirrors() {
    var editors = $(".editor").map(function (index, textarea) {
      var $textarea = $("#solution_content");
      var builder = new mumuki.editor.CodeMirrorBuilder(textarea);
      builder.setupEditor();
      builder.setupOptions($textarea.data('lines'));
      builder.setupLanguage();
      return builder.build();
    });

    return editors;
  }

  function onSelectUpdateCodeMirror() {
    $("#exercise_language_id").change(updateCodeMirrorLanguage);
  }

  function resetEditor() {
    mumuki.page.dynamicEditors.forEach(function (e) {
      setDefaultContent(e, $('#default_content').val());
    })
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

  function getContent(){
    return mumuki.page.editors.map(function (_, editor) {
      return editor.getValue();
    }).get().join("\n");
  }

  mumuki.editor = mumuki.editor || {};
  mumuki.editor.setupCodeMirrors = setEditorLanguage;
  mumuki.editor.toggleFullscreen = toggleFullscreen;
  mumuki.editor.indentWithSpaces = indentWithSpaces;
  mumuki.editor.getContent = getContent;

  mumuki.page = mumuki.page || {};
  mumuki.page.dynamicEditors = [];
  mumuki.page.editors = [];


  mumuki.load(function () {
    mumuki.page.editors = createCodeMirrors();
    updateCodeMirrorLanguage();
    onSelectUpdateCodeMirror();

    $('.editor-reset').click(function () {
      resetEditor();
    });
    $('.editor-resize').click(function () {
      toggleFullscreen();
    });

  });

}(mumuki));

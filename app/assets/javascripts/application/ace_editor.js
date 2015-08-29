var mumuki = mumuki || {};
mumuki.page = mumuki.page || {};

mumuki.page.dynamicEditors = [];
mumuki.page.editors = [];

mumuki.editor = mumuki.editor || {};
mumuki.editor.setupAceEditors = function () {
  var editors = $(".editor").map(function (index, textarea) {
    var builder = new mumuki.editor.AceEditorBuilder(textarea);
    builder.setupEditor();
    builder.setupOptions();
    builder.setupSubmit();
    builder.setupLanguage();
    return builder.build();
  });

  if (editors[0]) {
    editors[0].focus();
  }

  mumuki.page.editors = editors;
};
mumuki.editor.onSelectUpdateAceEditor = function () {
  $("#exercise_language_id").change(mumuki.editor.updateAceEditorLanguage);
};
mumuki.editor.updateAceEditorLanguage = function () {
  var language = $("#exercise_language_id").find(":selected").html() || $('#exercise_language').val();
  if (language !== undefined) {
    mumuki.page.dynamicEditors.forEach(function (e) {
      mumuki.editor.setEditorLanguage(e, language);
    })
  }
};
mumuki.editor.setEditorLanguage = function(editor, language) {
  editor.getSession().setMode("ace/mode/" + language.toLowerCase())
};

$(document).on('ready page:load', function () {
  mumuki.editor.setupAceEditors();
  mumuki.editor.updateAceEditorLanguage();
  mumuki.editor.onSelectUpdateAceEditor();
});


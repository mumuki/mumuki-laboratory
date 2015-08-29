var dynamicEditors;
var editors;

function setupAceEditors() {
  editors = $(".editor").map(function (index, textarea) {
    var builder = new AceEditorBuilder(textarea);
    builder.setupEditor();
    builder.setupOptions();
    builder.setupSubmit();
    builder.setupLanguage();
    return builder.build();
  });

  if (editors[0]) {
    editors[0].focus();
  }
}

function onSelectUpdateAceEditor() {
  $("#exercise_language_id").change(updateAceEditorLanguage);
}

function updateAceEditorLanguage() {
  var language = $("#exercise_language_id").find(":selected").html() || $('#exercise_language').val();
  if (language !== undefined) {
    dynamicEditors.forEach(function (e) {
      setEditorLanguage(e, language);
    })
  }
}

function setEditorLanguage(editor, language) {
  editor.getSession().setMode("ace/mode/" + language.toLowerCase())
}

$(document).on('ready page:load', function () {
  dynamicEditors = [];
  setupAceEditors();
  updateAceEditorLanguage();
  onSelectUpdateAceEditor();
});


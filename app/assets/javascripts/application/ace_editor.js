var dynamicEditors = [];

function setupEditorLanguage(textarea, editor) {
  var language = $(textarea).data('editor-language');
  if (language === 'dynamic') {
    dynamicEditors.push(editor);
  } else {
    setEditorLanguage(editor, language);
  }
}

function setupAceEditors() {
  var editors = $(".editor").map(function (index, textarea) {
    var editor = setupAceEditor(textarea);
    setupEditorLanguage(textarea, editor);
    return editor;
  });

  if (editors[0]) {
    editors[0].focus();
  }
}

function setupAceEditorOptions(editor) {
  editor.setOptions({
    minLines: 15,
    maxLines: Infinity,
    wrap: true
  });
  editor.setFontSize(13);
}

function setupAceEditorSubmit(textarea, editor) {
  var form = textarea.form;
  form.addEventListener("submit", function () {
    textarea.style.visibility = "hidden";
    textarea.value = editor.getValue();
    form.appendChild(textarea)
  });
}
function setupAceEditor(textarea) {
  var editor = ace.edit(textarea);
  editor.container.id = "editor-container";
  setupAceEditorOptions(editor);
  setupAceEditorSubmit(textarea, editor);
  return editor;
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
  setupAceEditors();
  updateAceEditorLanguage();
  onSelectUpdateAceEditor();
});


var dynamicEditors = [];

function setupAceEditors() {
  var editors = $(".editor").map(function (index, textarea) {
    var editor = setupAceEditor(textarea);
    var language = $(textarea).data('editor-language');
    if (language === 'dynamic') {
      dynamicEditors.push(editor);
    } else {
      setEditorLanguage(editor, language);
    }
    return editor;
  });

  if (editors[0]) {
    editors[0].focus();
  }
}

function setupAceEditor(textarea) {
  var form = textarea.form;

  var editor = ace.edit(textarea);
  editor.container.id = "editor-container";
  editor.setOptions({
    minLines: 15,
    maxLines: Infinity,
    wrap: true
  });
  editor.setFontSize(13);

  form.addEventListener("submit", function () {
    textarea.style.visibility = "hidden";
    textarea.value = editor.getValue();
    form.appendChild(textarea)
  });

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


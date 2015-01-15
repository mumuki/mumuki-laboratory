var editor = null;

function setupAceEditor() {
  var textarea = document.getElementById("editor");
  if (!textarea) {
    return;
  }
  var form = textarea.form;

  editor = ace.edit(textarea);
  editor.container.id = "editor-container";

  form.addEventListener("submit", function() {
    textarea.style.visibility = "hidden";
    textarea.value = editor.getValue();
    form.appendChild(textarea)
  });
}

function onSelectUpdateAceEditor() {
  $("#exercise_language_id").change(updateAceEditorLanguage);
}

function updateAceEditorLanguage() {
   var language = $("#exercise_language_id").find(":selected").html() || $('#exercise_language').val();
    if(language !== undefined) {
    editor.getSession().setMode("ace/mode/"+language.toLowerCase())
  }
}

$(function() {
  setupAceEditor();
  updateAceEditorLanguage();
  onSelectUpdateAceEditor();
});


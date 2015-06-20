var editors = [];

function setupAceEditors() {
  $(".editor").each(function(index, textarea){
    editors.push(setupAceEditor(textarea));
  });
}

function setupAceEditor(textarea) {
  var form = textarea.form;

  var editor = ace.edit(textarea);
  editor.container.id = "editor-container";
  editor.setOptions({
    minLines: 15,
    maxLines: Infinity
  });
  editor.setFontSize(13);

  form.addEventListener("submit", function() {
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
    editors.forEach(function (e) {
      e.getSession().setMode("ace/mode/" + language.toLowerCase())
    })
  }
}

$(document).on('ready page:load', function(){
  setupAceEditors();
  updateAceEditorLanguage();
  onSelectUpdateAceEditor();
});


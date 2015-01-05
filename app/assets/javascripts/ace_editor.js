function set_ace_editor() {
  var textarea = document.getElementById("editor");
  var form = textarea.form

  editor = ace.edit(textarea)
  editor.container.id = "ta"

  form.addEventListener("submit", function() {    
    textarea.style.visibility = "hidden"
    textarea.value = editor.getValue()
    form.appendChild(textarea)
  });
};


$(document).ready(function() {
  set_ace_editor();
});
$(document).ready(function() {
  $("#collapsible-width").on("click", function() {
    $(".exercise-description").toggleClass("hidden");
    $(".ace-editor-col").toggleClass("col-md-6");
    $(".ace-editor-col").toggleClass("col-md-12");
  })  
});
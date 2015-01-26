$(document).on('page:change',  function() {
  $('pre code').each(function(i, e) {hljs.highlightBlock(e)});
});
$(document).on('page:restore', function() {
  $('pre code').each(function(i, e) {hljs.highlightBlock(e)});
});

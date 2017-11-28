// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require application/load
//= require momentjs
//= require momentjs/locale/es
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require jquery-console

//= require codemirror.min
//= require codemirror-modes/clike.min.js
//= require codemirror-modes/closebrackets.min.js
//= require codemirror-modes/css.min.js
//= require codemirror-modes/css-hint.min.js
//= require codemirror-modes/haskell.min.js
//= require codemirror-modes/html-hint.min.js
//= require codemirror-modes/htmlmixed.min.js
//= require codemirror-modes/javascript.min.js
//= require codemirror-modes/javascript-hint.min
//= require codemirror-modes/markdown.min
//= require codemirror-modes/matchbrackets.min
//= require codemirror-modes/placeholder.min
//= require codemirror-modes/python.min
//= require codemirror-modes/ruby.min
//= require codemirror-modes/shell.min
//= require codemirror-modes/show-hint.min
//= require codemirror-modes/sql.min
//= require codemirror-modes/sql-hint.min
//= require codemirror-modes/xml.min
//= require codemirror-modes/xml-hint.min
//= require analytics
//= require hotjar
//= require facebook

//= require_tree ./application

NProgress.configure({
  showSpinner: false
});

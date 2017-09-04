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
//= require application/load.js
//= require momentjs
//= require momentjs/locale/es.js
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require codemirror
//= require codemirror/modes/ruby
//= require codemirror/modes/haskell
//= require codemirror/modes/javascript
//= require codemirror/modes/markdown
//= require codemirror/addons/edit/closebrackets
//= require codemirror/addons/edit/matchbrackets
//= require codemirror/addons/display/placeholder
//= require codemirror/addons/display/fullscreen
//= require codemirror/addons/hint/show-hint
//= require turbolinks
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require jquery-console
//= require_tree ./application

NProgress.configure({
    showSpinner: false
});

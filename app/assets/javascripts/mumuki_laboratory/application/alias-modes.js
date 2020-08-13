mumuki.load(() => {

  function CodeMirrorAlias(alias, current) {
    CodeMirror.defineMIME(alias, CodeMirror.mimeModes[current]);
  }

  CodeMirrorAlias('c', 'text/x-csrc');
  CodeMirrorAlias('cpp', 'text/x-c++src');
  CodeMirrorAlias('c_cpp', 'text/x-c++src');

  CodeMirrorAlias("html", "text/html");

  CodeMirrorAlias('java', 'text/x-java');

  CodeMirrorAlias('sql', 'text/x-sql');

  CodeMirrorAlias('sh', 'text/x-sh');
  CodeMirrorAlias('bash', 'text/x-sh');

});

// https://codemirror.net/demo/simplemode.html

(function() {
  var locale = document.querySelector("html").lang || 'es';
  var language = locale.split("-")[0];

  var keywords = [
    "program", "procedure", "function", "interactive", "if",
    "then", "else", "switch", "repeat", "while",
    "foreach", "in", "not", "div", "mod",
    "Skip", "return"
  ];

  var atoms = {
    es: ["Verde", "Rojo", "Azul", "Negro", "Norte", "Sur", "Este", "Oeste", "False", "True"],
    pt: ["Verde", "Vermelho", "Azul", "Preto", "Norte", "Sul", "Leste", "Oeste", "False", "True"],
    en: ["Green", "Red", "Blue", "Black", "North", "South", "East", "West", "False", "True"]
  };

  var builtins = {
    es: ["Poner", "Sacar", "Mover", "IrAlBorde", "VaciarTablero", "nroBolitas", "hayBolitas", "puedeMover", "siguiente", "previo", "opuesto", "minBool", "maxBool", "minDir", "maxDir", "minColor", "maxColor"],
    pt: ["Colocar", "Retirar", "Mover", "IrAlBorda", "VaciarTablero", "nroPedras", "haPedras", "podeMover", "seguinte", "previo", "oposto", "minBool", "maxBool", "minDir", "maxDir", "minCor", "maxCor"],
    en: ["Put", "Grab", "Move", "GoToEdge", "EmptyBoardContents", "numStones", "anyStones", "canMove", "next", "prev", "opposite", "minBool", "maxBool", "minDir", "maxDir", "minColor", "maxColor"]
  };

  const localizedKeywordsAndBuiltins = keywords.concat(builtins[language]);
  const localizedAtoms = atoms[language];

  var buildList = function(values) {
    return values.join('|');
  };

  CodeMirror.defineSimpleMode("gobstones", {
    // The start state contains the rules that are intially used
    start: [
      // The regex matches the token, the token property contains the type
      {regex: /"(?:[^\\]|\\.)*?(?:"|$)/, token: "string"},
      // You can match multiple tokens at once. Note that the captured
      // groups must span the whole string in this case
      {regex: /(function|procedure)(\s+)([a-zA-Z$][\w$]*)/, token: ["keyword", null, "variable-2"]},
      // Rules are matched in the order in which they appear, so there is
      // no ambiguity between this one and the one above
      {regex: new RegExp(`(?:${buildList(localizedKeywordsAndBuiltins)})\\b`), token: "keyword"},
      {regex: new RegExp(buildList(localizedAtoms)), token: "atom"},
      {regex: /[-+]?(\d+)/i, token: "number"},
      {regex: /\/\/.*/, token: "comment"},
      {regex: /\/(?:[^\\]|\\.)*?\//, token: "variable-3"},
      // A next property will cause the mode to move to a different state
      {regex: /\/\*/, token: "comment", next: "comment"},
      {regex: /(-|\+|\/|\*|\^|\|\||&&|:=|==|>=|<=|!=|<|>|!|div|mod)/, token: "operator"},
      // indent and dedent properties guide autoindentation
      {regex: /[\{\[\(]/, indent: true},
      {regex: /[\}\]\)]/, dedent: true},
      {regex: /[a-z]\w*/, token: "variable"}
    ],
    // The multi-line comment state.
    comment: [
      {regex: /.*?\*\//, token: "comment", next: "start"},
      {regex: /.*/, token: "comment"}
    ],
    // The meta property contains global information about the mode. It
    // can contain properties like lineComment, which are supported by
    // all modes, and also directives like dontIndentStates, which are
    // specific to simple modes.
    meta: {
      dontIndentStates: ["comment"],
      lineComment: "//"
    }
  });

  CodeMirror.defineMIME("text/x-gobstones", "gobstones");
})();

function registerAutocoplete(mode, keywords, identifierRegex) {

    var regex = identifierRegex || /[a-zA-Z_$][a-zA-Z0-9_$]*\b/;

    function isIdentifier(name) {
        return regex.test(name.trim());
    }

    CodeMirror.registerHelper('hint', mode, function (editor, options) {
        var WORD = /[\w$]+/;

        var word = options && options.word || WORD;
        var cur = editor.getCursor();
        var curLine = editor.getLine(cur.line);
        var end = cur.ch;
        var start = end;

        var words = {};
        editor.getValue().split(/([^a-zA-Z0-9_$])|[\[\]{}() \n\t]/).concat(keywords).forEach(function (name) {
            if (isIdentifier(name)) words[name.trim()] = true;
        });

        while (start && word.test(curLine.charAt(start - 1))) --start;

        var curWord = curLine.slice(start, end);

        var list = [];

        for (var aWord in words) {
            if (aWord.toLowerCase().indexOf(curWord.toLowerCase()) === 0) {
                list.push(aWord);
            }
        }

        list.sort && list.sort();

        return {
            list: list,
            from: CodeMirror.Pos(cur.line, start),
            to: CodeMirror.Pos(cur.line, end)
        };
    });

}

registerAutocoplete('gobstones', (
    'program procedure function interactive if then else switch repeat while foreach in not div mod Skip return ' +
    'False True Poner Sacar Mover IrAlBorde VaciarTablero nroBolitas hayBolitas puedeMover siguiente previo opuesto ' +
    'minBool maxBool minDir maxDir minColor maxColor Verde Rojo Azul Negro Norte Sur Este Oeste'
).split(' '));

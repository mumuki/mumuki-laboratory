// Parts from Ace; see <https://raw.githubusercontent.com/ajaxorg/ace/master/LICENSE>
CodeMirror.defineMode("elixir", function(cmCfg, modeCfg) {

  // Fake define() function.
  var moduleHolder = Object.create(null);

  // Given a module path as a string, create the canonical version
  // (no leading ./, no ending .js).
  var canonicalPath = function(path) {
    return path.replace(/\.\//, '').replace(/\.js$/, '');
  };

  // We intentionally add the `path` argument to `define()`.
  var define = function(path, init) {
    var exports = Object.create(null);
    init(require, exports);  // module (3rd parameter) isn't supported.
    moduleHolder[canonicalPath(path)] = exports;
  };

  // path: string of the location of the JS file.
  var require = function(path) { return moduleHolder[canonicalPath(path)]; };

  // All dependencies here.
  define("../lib/oop.js", function(require, exports, module) {
    "use strict";
    
    exports.inherits = function(ctor, superCtor) {
        ctor.super_ = superCtor;
        ctor.prototype = Object.create(superCtor.prototype, {
            constructor: {
                value: ctor,
                enumerable: false,
                writable: true,
                configurable: true
            }
        });
    };
    
    exports.mixin = function(obj, mixin) {
        for (var key in mixin) {
            obj[key] = mixin[key];
        }
        return obj;
    };
    
    exports.implement = function(proto, mixin) {
        exports.mixin(proto, mixin);
    };
    
    });
    

  define("../lib/lang.js", function(require, exports, module) {
    "use strict";
    
    exports.last = function(a) {
        return a[a.length - 1];
    };
    
    exports.stringReverse = function(string) {
        return string.split("").reverse().join("");
    };
    
    exports.stringRepeat = function (string, count) {
        var result = '';
        while (count > 0) {
            if (count & 1)
                result += string;
    
            if (count >>= 1)
                string += string;
        }
        return result;
    };
    
    var trimBeginRegexp = /^\s\s*/;
    var trimEndRegexp = /\s\s*$/;
    
    exports.stringTrimLeft = function (string) {
        return string.replace(trimBeginRegexp, '');
    };
    
    exports.stringTrimRight = function (string) {
        return string.replace(trimEndRegexp, '');
    };
    
    exports.copyObject = function(obj) {
        var copy = {};
        for (var key in obj) {
            copy[key] = obj[key];
        }
        return copy;
    };
    
    exports.copyArray = function(array){
        var copy = [];
        for (var i=0, l=array.length; i<l; i++) {
            if (array[i] && typeof array[i] == "object")
                copy[i] = this.copyObject(array[i]);
            else 
                copy[i] = array[i];
        }
        return copy;
    };
    
    exports.deepCopy = function deepCopy(obj) {
        if (typeof obj !== "object" || !obj)
            return obj;
        var copy;
        if (Array.isArray(obj)) {
            copy = [];
            for (var key = 0; key < obj.length; key++) {
                copy[key] = deepCopy(obj[key]);
            }
            return copy;
        }
        if (Object.prototype.toString.call(obj) !== "[object Object]")
            return obj;
        
        copy = {};
        for (var key in obj)
            copy[key] = deepCopy(obj[key]);
        return copy;
    };
    
    exports.arrayToMap = function(arr) {
        var map = {};
        for (var i=0; i<arr.length; i++) {
            map[arr[i]] = 1;
        }
        return map;
    
    };
    
    exports.createMap = function(props) {
        var map = Object.create(null);
        for (var i in props) {
            map[i] = props[i];
        }
        return map;
    };
    
    /*
     * splice out of 'array' anything that === 'value'
     */
    exports.arrayRemove = function(array, value) {
      for (var i = 0; i <= array.length; i++) {
        if (value === array[i]) {
          array.splice(i, 1);
        }
      }
    };
    
    exports.escapeRegExp = function(str) {
        return str.replace(/([.*+?^${}()|[\]\/\\])/g, '\\$1');
    };
    
    exports.escapeHTML = function(str) {
        return str.replace(/&/g, "&#38;").replace(/"/g, "&#34;").replace(/'/g, "&#39;").replace(/</g, "&#60;");
    };
    
    exports.getMatchOffsets = function(string, regExp) {
        var matches = [];
    
        string.replace(regExp, function(str) {
            matches.push({
                offset: arguments[arguments.length-2],
                length: str.length
            });
        });
    
        return matches;
    };
    
    /* deprecated */
    exports.deferredCall = function(fcn) {
        var timer = null;
        var callback = function() {
            timer = null;
            fcn();
        };
    
        var deferred = function(timeout) {
            deferred.cancel();
            timer = setTimeout(callback, timeout || 0);
            return deferred;
        };
    
        deferred.schedule = deferred;
    
        deferred.call = function() {
            this.cancel();
            fcn();
            return deferred;
        };
    
        deferred.cancel = function() {
            clearTimeout(timer);
            timer = null;
            return deferred;
        };
        
        deferred.isPending = function() {
            return timer;
        };
    
        return deferred;
    };
    
    
    exports.delayedCall = function(fcn, defaultTimeout) {
        var timer = null;
        var callback = function() {
            timer = null;
            fcn();
        };
    
        var _self = function(timeout) {
            if (timer == null)
                timer = setTimeout(callback, timeout || defaultTimeout);
        };
    
        _self.delay = function(timeout) {
            timer && clearTimeout(timer);
            timer = setTimeout(callback, timeout || defaultTimeout);
        };
        _self.schedule = _self;
    
        _self.call = function() {
            this.cancel();
            fcn();
        };
    
        _self.cancel = function() {
            timer && clearTimeout(timer);
            timer = null;
        };
    
        _self.isPending = function() {
            return timer;
        };
    
        return _self;
    };
    });
    

  define("./text_highlight_rules.js", function(require, exports, module) {
    "use strict";
    
    var lang = require("../lib/lang");
    
    var TextHighlightRules = function() {
    
        // regexp must not have capturing parentheses
        // regexps are ordered -> the first match is used
    
        this.$rules = {
            "start" : [{
                token : "empty_line",
                regex : '^$'
            }, {
                defaultToken : "text"
            }]
        };
    };
    
    (function() {
    
        this.addRules = function(rules, prefix) {
            if (!prefix) {
                for (var key in rules)
                    this.$rules[key] = rules[key];
                return;
            }
            for (var key in rules) {
                var state = rules[key];
                for (var i = 0; i < state.length; i++) {
                    var rule = state[i];
                    if (rule.next || rule.onMatch) {
                        if (typeof rule.next == "string") {
                            if (rule.next.indexOf(prefix) !== 0)
                                rule.next = prefix + rule.next;
                        }
                        if (rule.nextState && rule.nextState.indexOf(prefix) !== 0)
                            rule.nextState = prefix + rule.nextState;
                    }
                }
                this.$rules[prefix + key] = state;
            }
        };
    
        this.getRules = function() {
            return this.$rules;
        };
    
        this.embedRules = function (HighlightRules, prefix, escapeRules, states, append) {
            var embedRules = typeof HighlightRules == "function"
                ? new HighlightRules().getRules()
                : HighlightRules;
            if (states) {
                for (var i = 0; i < states.length; i++)
                    states[i] = prefix + states[i];
            } else {
                states = [];
                for (var key in embedRules)
                    states.push(prefix + key);
            }
    
            this.addRules(embedRules, prefix);
    
            if (escapeRules) {
                var addRules = Array.prototype[append ? "push" : "unshift"];
                for (var i = 0; i < states.length; i++)
                    addRules.apply(this.$rules[states[i]], lang.deepCopy(escapeRules));
            }
    
            if (!this.$embeds)
                this.$embeds = [];
            this.$embeds.push(prefix);
        };
    
        this.getEmbeds = function() {
            return this.$embeds;
        };
    
        var pushState = function(currentState, stack) {
            if (currentState != "start" || stack.length)
                stack.unshift(this.nextState, currentState);
            return this.nextState;
        };
        var popState = function(currentState, stack) {
            // if (stack[0] === currentState)
            stack.shift();
            return stack.shift() || "start";
        };
    
        this.normalizeRules = function() {
            var id = 0;
            var rules = this.$rules;
            function processState(key) {
                var state = rules[key];
                state.processed = true;
                for (var i = 0; i < state.length; i++) {
                    var rule = state[i];
                    var toInsert = null;
                    if (Array.isArray(rule)) {
                        toInsert = rule;
                        rule = {};
                    }
                    if (!rule.regex && rule.start) {
                        rule.regex = rule.start;
                        if (!rule.next)
                            rule.next = [];
                        rule.next.push({
                            defaultToken: rule.token
                        }, {
                            token: rule.token + ".end",
                            regex: rule.end || rule.start,
                            next: "pop"
                        });
                        rule.token = rule.token + ".start";
                        rule.push = true;
                    }
                    var next = rule.next || rule.push;
                    if (next && Array.isArray(next)) {
                        var stateName = rule.stateName;
                        if (!stateName)  {
                            stateName = rule.token;
                            if (typeof stateName != "string")
                                stateName = stateName[0] || "";
                            if (rules[stateName])
                                stateName += id++;
                        }
                        rules[stateName] = next;
                        rule.next = stateName;
                        processState(stateName);
                    } else if (next == "pop") {
                        rule.next = popState;
                    }
    
                    if (rule.push) {
                        rule.nextState = rule.next || rule.push;
                        rule.next = pushState;
                        delete rule.push;
                    }
    
                    if (rule.rules) {
                        for (var r in rule.rules) {
                            if (rules[r]) {
                                if (rules[r].push)
                                    rules[r].push.apply(rules[r], rule.rules[r]);
                            } else {
                                rules[r] = rule.rules[r];
                            }
                        }
                    }
                    var includeName = typeof rule == "string" ? rule : rule.include;
                    if (includeName) {
                        if (Array.isArray(includeName))
                            toInsert = includeName.map(function(x) { return rules[x]; });
                        else
                            toInsert = rules[includeName];
                    }
    
                    if (toInsert) {
                        var args = [i, 1].concat(toInsert);
                        if (rule.noEscape)
                            args = args.filter(function(x) {return !x.next;});
                        state.splice.apply(state, args);
                        // skip included rules since they are already processed
                        //i += args.length - 3;
                        i--;
                    }
                    
                    if (rule.keywordMap) {
                        rule.token = this.createKeywordMapper(
                            rule.keywordMap, rule.defaultToken || "text", rule.caseInsensitive
                        );
                        delete rule.defaultToken;
                    }
                }
            }
            Object.keys(rules).forEach(processState, this);
        };
    
        this.createKeywordMapper = function(map, defaultToken, ignoreCase, splitChar) {
            var keywords = Object.create(null);
            Object.keys(map).forEach(function(className) {
                var a = map[className];
                if (ignoreCase)
                    a = a.toLowerCase();
                var list = a.split(splitChar || "|");
                for (var i = list.length; i--; )
                    keywords[list[i]] = className;
            });
            // in old versions of opera keywords["__proto__"] sets prototype
            // even on objects with __proto__=null
            if (Object.getPrototypeOf(keywords)) {
                keywords.__proto__ = null;
            }
            this.$keywordList = Object.keys(keywords);
            map = null;
            return ignoreCase
                ? function(value) {return keywords[value.toLowerCase()] || defaultToken; }
                : function(value) {return keywords[value] || defaultToken; };
        };
    
        this.getKeywords = function() {
            return this.$keywords;
        };
    
    }).call(TextHighlightRules.prototype);
    
    exports.TextHighlightRules = TextHighlightRules;
    });
    

  define("elixir_highlight_rules", function(require, exports, module) {
    "use strict";
    
    var oop = require("../lib/oop");
    var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;
    
    var ElixirHighlightRules = function() {
        // regexp must not have capturing parentheses. Use (?:) instead.
        // regexps are ordered -> the first match is used
    
        this.$rules = { start: 
           [ { token: 
                [ 'meta.module.elixir',
                  'keyword.control.module.elixir',
                  'meta.module.elixir',
                  'entity.name.type.module.elixir' ],
               regex: '^(\\s*)(defmodule)(\\s+)((?:[A-Z]\\w*\\s*\\.\\s*)*[A-Z]\\w*)' },
             { token: 'comment.documentation.heredoc',
               regex: '@(?:module|type)?doc (?:~[a-z])?"""',
               push: 
                [ { token: 'comment.documentation.heredoc',
                    regex: '\\s*"""',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'comment.documentation.heredoc' } ],
               comment: '@doc with heredocs is treated as documentation' },
             { token: 'comment.documentation.heredoc',
               regex: '@(?:module|type)?doc ~[A-Z]"""',
               push: 
                [ { token: 'comment.documentation.heredoc',
                    regex: '\\s*"""',
                    next: 'pop' },
                  { defaultToken: 'comment.documentation.heredoc' } ],
               comment: '@doc with heredocs is treated as documentation' },
             { token: 'comment.documentation.heredoc',
               regex: '@(?:module|type)?doc (?:~[a-z])?\'\'\'',
               push: 
                [ { token: 'comment.documentation.heredoc',
                    regex: '\\s*\'\'\'',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'comment.documentation.heredoc' } ],
               comment: '@doc with heredocs is treated as documentation' },
             { token: 'comment.documentation.heredoc',
               regex: '@(?:module|type)?doc ~[A-Z]\'\'\'',
               push: 
                [ { token: 'comment.documentation.heredoc',
                    regex: '\\s*\'\'\'',
                    next: 'pop' },
                  { defaultToken: 'comment.documentation.heredoc' } ],
               comment: '@doc with heredocs is treated as documentation' },
             { token: 'comment.documentation.false',
               regex: '@(?:module|type)?doc false',
               comment: '@doc false is treated as documentation' },
             { token: 'comment.documentation.string',
               regex: '@(?:module|type)?doc "',
               push: 
                [ { token: 'comment.documentation.string',
                    regex: '"',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'comment.documentation.string' } ],
               comment: '@doc with string is treated as documentation' },
             { token: 'keyword.control.elixir',
               regex: '\\b(?:do|end|case|bc|lc|for|if|cond|unless|try|receive|fn|defmodule|defp?|defprotocol|defimpl|defrecord|defstruct|defmacrop?|defdelegate|defcallback|defmacrocallback|defexception|defoverridable|exit|after|rescue|catch|else|raise|throw|import|require|alias|use|quote|unquote|super)\\b(?![?!])',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?<!\\.)\\b(do|end|case|bc|lc|for|if|cond|unless|try|receive|fn|defmodule|defp?|defprotocol|defimpl|defrecord|defstruct|defmacrop?|defdelegate|defcallback|defmacrocallback|defexception|defoverridable|exit|after|rescue|catch|else|raise|throw|import|require|alias|use|quote|unquote|super)\\b(?![?!])' },
             { token: 'keyword.operator.elixir',
               regex: '\\b(?:and|not|or|when|xor|in|inlist|inbits)\\b',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?<!\\.)\\b(and|not|or|when|xor|in|inlist|inbits)\\b',
               comment: ' as above, just doesn\'t need a \'end\' and does a logic operation' },
             { token: 'constant.language.elixir',
               regex: '\\b(?:nil|true|false)\\b(?![?!])' },
             { token: 'variable.language.elixir',
               regex: '\\b__(?:CALLER|ENV|MODULE|DIR)__\\b(?![?!])' },
             { token: 
                [ 'punctuation.definition.variable.elixir',
                  'variable.other.readwrite.module.elixir' ],
               regex: '(@)([a-zA-Z_]\\w*)' },
             { token: 
                [ 'punctuation.definition.variable.elixir',
                  'variable.other.anonymous.elixir' ],
               regex: '(&)(\\d*)' },
             { token: 'variable.other.constant.elixir',
               regex: '\\b[A-Z]\\w*\\b' },
             { token: 'constant.numeric.elixir',
               regex: '\\b(?:0x[\\da-fA-F](?:_?[\\da-fA-F])*|\\d(?:_?\\d)*(?:\\.(?![^[:space:][:digit:]])(?:_?\\d)*)?(?:[eE][-+]?\\d(?:_?\\d)*)?|0b[01]+|0o[0-7]+)\\b',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '\\b(0x\\h(?>_?\\h)*|\\d(?>_?\\d)*(\\.(?![^[:space:][:digit:]])(?>_?\\d)*)?([eE][-+]?\\d(?>_?\\d)*)?|0b[01]+|0o[0-7]+)\\b' },
             { token: 'punctuation.definition.constant.elixir',
               regex: ':\'',
               push: 
                [ { token: 'punctuation.definition.constant.elixir',
                    regex: '\'',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'constant.other.symbol.single-quoted.elixir' } ] },
             { token: 'punctuation.definition.constant.elixir',
               regex: ':"',
               push: 
                [ { token: 'punctuation.definition.constant.elixir',
                    regex: '"',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'constant.other.symbol.double-quoted.elixir' } ] },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '(?:\'\'\')',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?>\'\'\')',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '^\\s*\'\'\'',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'support.function.variable.quoted.single.heredoc.elixir' } ],
               comment: 'Single-quoted heredocs' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '\'',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\'',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'support.function.variable.quoted.single.elixir' } ],
               comment: 'single quoted string (allows for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '(?:""")',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?>""")',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '^\\s*"""',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.quoted.double.heredoc.elixir' } ],
               comment: 'Double-quoted heredocs' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '"',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '"',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.quoted.double.elixir' } ],
               comment: 'double quoted string (allows for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z](?:""")',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '~[a-z](?>""")',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '^\\s*"""',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.quoted.double.heredoc.elixir' } ],
               comment: 'Double-quoted heredocs sigils' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z]\\{',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\}[a-z]*',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.interpolated.elixir' } ],
               comment: 'sigil (allow for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z]\\[',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\][a-z]*',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.interpolated.elixir' } ],
               comment: 'sigil (allow for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z]\\<',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\>[a-z]*',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.interpolated.elixir' } ],
               comment: 'sigil (allow for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z]\\(',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\)[a-z]*',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.interpolated.elixir' } ],
               comment: 'sigil (allow for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[a-z][^\\w]',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '[^\\w][a-z]*',
                    next: 'pop' },
                  { include: '#interpolated_elixir' },
                  { include: '#escaped_char' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.interpolated.elixir' } ],
               comment: 'sigil (allow for interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z](?:""")',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '~[A-Z](?>""")',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '^\\s*"""',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'Double-quoted heredocs sigils' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z]\\{',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\}[a-z]*',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'sigil (without interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z]\\[',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\][a-z]*',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'sigil (without interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z]\\<',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\>[a-z]*',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'sigil (without interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z]\\(',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '\\)[a-z]*',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'sigil (without interpolation)' },
             { token: 'punctuation.definition.string.begin.elixir',
               regex: '~[A-Z][^\\w]',
               push: 
                [ { token: 'punctuation.definition.string.end.elixir',
                    regex: '[^\\w][a-z]*',
                    next: 'pop' },
                  { defaultToken: 'string.quoted.other.literal.upper.elixir' } ],
               comment: 'sigil (without interpolation)' },
             { token: ['punctuation.definition.constant.elixir', 'constant.other.symbol.elixir'],
               regex: '(:)([a-zA-Z_][\\w@]*(?:[?!]|=(?![>=]))?|\\<\\>|===?|!==?|<<>>|<<<|>>>|~~~|::|<\\-|\\|>|=>|~|~=|=|/|\\\\\\\\|\\*\\*?|\\.\\.?\\.?|>=?|<=?|&&?&?|\\+\\+?|\\-\\-?|\\|\\|?\\|?|\\!|@|\\%?\\{\\}|%|\\[\\]|\\^(?:\\^\\^)?)',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?<!:)(:)(?>[a-zA-Z_][\\w@]*(?>[?!]|=(?![>=]))?|\\<\\>|===?|!==?|<<>>|<<<|>>>|~~~|::|<\\-|\\|>|=>|~|~=|=|/|\\\\\\\\|\\*\\*?|\\.\\.?\\.?|>=?|<=?|&&?&?|\\+\\+?|\\-\\-?|\\|\\|?\\|?|\\!|@|\\%?\\{\\}|%|\\[\\]|\\^(\\^\\^)?)',
               comment: 'symbols' },
             { token: 'punctuation.definition.constant.elixir',
               regex: '(?:[a-zA-Z_][\\w@]*(?:[?!])?):(?!:)',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?>[a-zA-Z_][\\w@]*(?>[?!])?)(:)(?!:)',
               comment: 'symbols' },
             { token: 
                [ 'punctuation.definition.comment.elixir',
                  'comment.line.number-sign.elixir' ],
               regex: '(#)(.*)' },
             { token: 'constant.numeric.elixir',
               regex: '\\?(?:\\\\(?:x[\\da-fA-F]{1,2}(?![\\da-fA-F])\\b|[^xMC])|[^\\s\\\\])',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?<!\\w)\\?(\\\\(x\\h{1,2}(?!\\h)\\b|[^xMC])|[^\\s\\\\])',
               comment: '\n\t\t\tmatches questionmark-letters.\n\n\t\t\texamples (1st alternation = hex):\n\t\t\t?\\x1     ?\\x61\n\n\t\t\texamples (2rd alternation = escaped):\n\t\t\t?\\n      ?\\b\n\n\t\t\texamples (3rd alternation = normal):\n\t\t\t?a       ?A       ?0 \n\t\t\t?*       ?"       ?( \n\t\t\t?.       ?#\n\t\t\t\n\t\t\tthe negative lookbehind prevents against matching\n\t\t\tp(42.tainted?)\n\t\t\t' },
            /* { token: 'punctuation.separator.variable.elixir',
               regex: '(?<=\\{|do|\\{\\s|do\\s)\\|',
               TODO: 'FIXME: regexp doesn\'t have js equivalent',
               originalRegex: '(?<=\\{|do|\\{\\s|do\\s)(\\|)',
               push: 
                [ { token: 'punctuation.separator.variable.elixir',
                    regex: '\\|',
                    next: 'pop' },
                  { token: 'variable.other.block.elixir',
                    regex: '[_a-zA-Z][_a-zA-Z0-9]*' },
                  { token: 'punctuation.separator.variable.elixir', regex: ',' } ] },*/
             { token: 'keyword.operator.assignment.augmented.elixir',
               regex: '\\+=|\\-=|\\|\\|=|~=|&&=' },
             { token: 'keyword.operator.comparison.elixir',
               regex: '===?|!==?|<=?|>=?' },
             { token: 'keyword.operator.bitwise.elixir',
               regex: '\\|{3}|&{3}|\\^{3}|<{3}|>{3}|~{3}' },
             { token: 'keyword.operator.logical.elixir',
               regex: '!+|\\bnot\\b|&&|\\band\\b|\\|\\||\\bor\\b|\\bxor\\b',
               originalRegex: '(?<=[ \\t])!+|\\bnot\\b|&&|\\band\\b|\\|\\||\\bor\\b|\\bxor\\b' },
             { token: 'keyword.operator.arithmetic.elixir',
               regex: '\\*|\\+|\\-|/' },
             { token: 'keyword.operator.other.elixir',
               regex: '\\||\\+\\+|\\-\\-|\\*\\*|\\\\\\\\|\\<\\-|\\<\\>|\\<\\<|\\>\\>|\\:\\:|\\.\\.|\\|>|~|=>' },
             { token: 'keyword.operator.assignment.elixir', regex: '=' },
             { token: 'punctuation.separator.other.elixir', regex: ':' },
             { token: 'punctuation.separator.statement.elixir',
               regex: '\\;' },
             { token: 'punctuation.separator.object.elixir', regex: ',' },
             { token: 'punctuation.separator.method.elixir', regex: '\\.' },
             { token: 'punctuation.section.scope.elixir', regex: '\\{|\\}' },
             { token: 'punctuation.section.array.elixir', regex: '\\[|\\]' },
             { token: 'punctuation.section.function.elixir',
               regex: '\\(|\\)' } ],
          '#escaped_char': 
           [ { token: 'constant.character.escape.elixir',
               regex: '\\\\(?:x[\\da-fA-F]{1,2}|.)' } ],
          '#interpolated_elixir': 
           [ { token: 
                [ 'source.elixir.embedded.source',
                  'source.elixir.embedded.source.empty' ],
               regex: '(#\\{)(\\})' },
             { todo: 
                { token: 'punctuation.section.embedded.elixir',
                  regex: '#\\{',
                  push: 
                   [ { token: 'punctuation.section.embedded.elixir',
                       regex: '\\}',
                       next: 'pop' },
                     { include: '#nest_curly_and_self' },
                     { include: '$self' },
                     { defaultToken: 'source.elixir.embedded.source' } ] } } ],
          '#nest_curly_and_self': 
           [ { token: 'punctuation.section.scope.elixir',
               regex: '\\{',
               push: 
                [ { token: 'punctuation.section.scope.elixir',
                    regex: '\\}',
                    next: 'pop' },
                  { include: '#nest_curly_and_self' } ] },
             { include: '$self' } ],
          '#regex_sub': 
           [ { include: '#interpolated_elixir' },
             { include: '#escaped_char' },
             { token: 
                [ 'punctuation.definition.arbitrary-repitition.elixir',
                  'string.regexp.arbitrary-repitition.elixir',
                  'string.regexp.arbitrary-repitition.elixir',
                  'punctuation.definition.arbitrary-repitition.elixir' ],
               regex: '(\\{)(\\d+)((?:,\\d+)?)(\\})' },
             { token: 'punctuation.definition.character-class.elixir',
               regex: '\\[(?:\\^?\\])?',
               push: 
                [ { token: 'punctuation.definition.character-class.elixir',
                    regex: '\\]',
                    next: 'pop' },
                  { include: '#escaped_char' },
                  { defaultToken: 'string.regexp.character-class.elixir' } ] },
             { token: 'punctuation.definition.group.elixir',
               regex: '\\(',
               push: 
                [ { token: 'punctuation.definition.group.elixir',
                    regex: '\\)',
                    next: 'pop' },
                  { include: '#regex_sub' },
                  { defaultToken: 'string.regexp.group.elixir' } ] },
             { token: 
                [ 'punctuation.definition.comment.elixir',
                  'comment.line.number-sign.elixir' ],
               regex: '(?:^|\\s)(#)(\\s[[a-zA-Z0-9,. \\t?!-][^\\x00-\\x7F]]*$)',
               originalRegex: '(?<=^|\\s)(#)\\s[[a-zA-Z0-9,. \\t?!-][^\\x{00}-\\x{7F}]]*$',
               comment: 'We are restrictive in what we allow to go after the comment character to avoid false positives, since the availability of comments depend on regexp flags.' } ] };
        
        this.normalizeRules();
    };
    
    ElixirHighlightRules.metaData = { comment: 'Textmate bundle for Elixir Programming Language.',
          fileTypes: [ 'ex', 'exs' ],
          firstLineMatch: '^#!/.*\\belixir',
          foldingStartMarker: '(after|else|catch|rescue|\\-\\>|\\{|\\[|do)\\s*$',
          foldingStopMarker: '^\\s*((\\}|\\]|after|else|catch|rescue)\\s*$|end\\b)',
          keyEquivalent: '^~E',
          name: 'Elixir',
          scopeName: 'source.elixir' };
    
    
    oop.inherits(ElixirHighlightRules, TextHighlightRules);
    
    exports.ElixirHighlightRules = ElixirHighlightRules;
    });


  // Ace highlight rules function imported below.
  var HighlightRules = require("elixir_highlight_rules").ElixirHighlightRules;

  

  // Ace's Syntax Tokenizer.

  // tokenizing lines longer than this makes editor very slow
  var MAX_TOKEN_COUNT = 1000;
  var Tokenizer = function(rules) {
      this.states = rules;

      this.regExps = {};
      this.matchMappings = {};
      for (var key in this.states) {
          var state = this.states[key];
          var ruleRegExps = [];
          var matchTotal = 0;
          var mapping = this.matchMappings[key] = {defaultToken: "text"};
          var flag = "g";

          var splitterRurles = [];
          for (var i = 0; i < state.length; i++) {
              var rule = state[i];
              if (rule.defaultToken)
                  mapping.defaultToken = rule.defaultToken;
              if (rule.caseInsensitive)
                  flag = "gi";
              if (rule.regex == null)
                  continue;

              if (rule.regex instanceof RegExp)
                  rule.regex = rule.regex.toString().slice(1, -1);

              // Count number of matching groups. 2 extra groups from the full match
              // And the catch-all on the end (used to force a match);
              var adjustedregex = rule.regex;
              var matchcount = new RegExp("(?:(" + adjustedregex + ")|(.))").exec("a").length - 2;
              if (Array.isArray(rule.token)) {
                  if (rule.token.length == 1 || matchcount == 1) {
                      rule.token = rule.token[0];
                  } else if (matchcount - 1 != rule.token.length) {
                      throw new Error("number of classes and regexp groups in '" + 
                          rule.token + "'\n'" + rule.regex +  "' doesn't match\n"
                          + (matchcount - 1) + "!=" + rule.token.length);
                  } else {
                      rule.tokenArray = rule.token;
                      rule.token = null;
                      rule.onMatch = this.$arrayTokens;
                  }
              } else if (typeof rule.token == "function" && !rule.onMatch) {
                  if (matchcount > 1)
                      rule.onMatch = this.$applyToken;
                  else
                      rule.onMatch = rule.token;
              }

              if (matchcount > 1) {
                  if (/\\\d/.test(rule.regex)) {
                      // Replace any backreferences and offset appropriately.
                      adjustedregex = rule.regex.replace(/\\([0-9]+)/g, function(match, digit) {
                          return "\\" + (parseInt(digit, 10) + matchTotal + 1);
                      });
                  } else {
                      matchcount = 1;
                      adjustedregex = this.removeCapturingGroups(rule.regex);
                  }
                  if (!rule.splitRegex && typeof rule.token != "string")
                      splitterRurles.push(rule); // flag will be known only at the very end
              }

              mapping[matchTotal] = i;
              matchTotal += matchcount;

              ruleRegExps.push(adjustedregex);

              // makes property access faster
              if (!rule.onMatch)
                  rule.onMatch = null;
          }
          
          splitterRurles.forEach(function(rule) {
              rule.splitRegex = this.createSplitterRegexp(rule.regex, flag);
          }, this);

          this.regExps[key] = new RegExp("(" + ruleRegExps.join(")|(") + ")|($)", flag);
      }
  };

  (function() {
      this.$setMaxTokenCount = function(m) {
          MAX_TOKEN_COUNT = m | 0;
      };
      
      this.$applyToken = function(str) {
          var values = this.splitRegex.exec(str).slice(1);
          var types = this.token.apply(this, values);

          // required for compatibility with old modes
          if (typeof types === "string")
              return [{type: types, value: str}];

          var tokens = [];
          for (var i = 0, l = types.length; i < l; i++) {
              if (values[i])
                  tokens[tokens.length] = {
                      type: types[i],
                      value: values[i]
                  };
          }
          return tokens;
      },

      this.$arrayTokens = function(str) {
          if (!str)
              return [];
          var values = this.splitRegex.exec(str);
          if (!values)
              return "text";
          var tokens = [];
          var types = this.tokenArray;
          for (var i = 0, l = types.length; i < l; i++) {
              if (values[i + 1])
                  tokens[tokens.length] = {
                      type: types[i],
                      value: values[i + 1]
                  };
          }
          return tokens;
      };

      this.removeCapturingGroups = function(src) {
          var r = src.replace(
              /\[(?:\\.|[^\]])*?\]|\\.|\(\?[:=!]|(\()/g,
              function(x, y) {return y ? "(?:" : x;}
          );
          return r;
      };

      this.createSplitterRegexp = function(src, flag) {
          if (src.indexOf("(?=") != -1) {
              var stack = 0;
              var inChClass = false;
              var lastCapture = {};
              src.replace(/(\\.)|(\((?:\?[=!])?)|(\))|([\[\]])/g, function(
                  m, esc, parenOpen, parenClose, square, index
              ) {
                  if (inChClass) {
                      inChClass = square != "]";
                  } else if (square) {
                      inChClass = true;
                  } else if (parenClose) {
                      if (stack == lastCapture.stack) {
                          lastCapture.end = index+1;
                          lastCapture.stack = -1;
                      }
                      stack--;
                  } else if (parenOpen) {
                      stack++;
                      if (parenOpen.length != 1) {
                          lastCapture.stack = stack
                          lastCapture.start = index;
                      }
                  }
                  return m;
              });

              if (lastCapture.end != null && /^\)*$/.test(src.substr(lastCapture.end)))
                  src = src.substring(0, lastCapture.start) + src.substr(lastCapture.end);
          }
          return new RegExp(src, (flag||"").replace("g", ""));
      };

      /**
      * Returns an object containing two properties: `tokens`, which contains all the tokens; and `state`, the current state.
      * @returns {Object}
      **/
      this.getLineTokens = function(line, startState) {
          if (startState && typeof startState != "string") {
              var stack = startState.slice(0);
              startState = stack[0];
          } else
              var stack = [];

          var currentState = startState || "start";
          var state = this.states[currentState];
          if (!state) {
              currentState = "start";
              state = this.states[currentState];
          }
          var mapping = this.matchMappings[currentState];
          var re = this.regExps[currentState];
          re.lastIndex = 0;

          var match, tokens = [];
          var lastIndex = 0;

          var token = {type: null, value: ""};

          while (match = re.exec(line)) {
              var type = mapping.defaultToken;
              var rule = null;
              var value = match[0];
              var index = re.lastIndex;

              if (index - value.length > lastIndex) {
                  var skipped = line.substring(lastIndex, index - value.length);
                  if (token.type == type) {
                      token.value += skipped;
                  } else {
                      if (token.type)
                          tokens.push(token);
                      token = {type: type, value: skipped};
                  }
              }

              for (var i = 0; i < match.length-2; i++) {
                  if (match[i + 1] === undefined)
                      continue;

                  rule = state[mapping[i]];

                  if (rule.onMatch)
                      type = rule.onMatch(value, currentState, stack);
                  else
                      type = rule.token;

                  if (rule.next) {
                      if (typeof rule.next == "string")
                          currentState = rule.next;
                      else
                          currentState = rule.next(currentState, stack);

                      state = this.states[currentState];
                      if (!state) {
                          window.console && console.error && console.error(currentState, "doesn't exist");
                          currentState = "start";
                          state = this.states[currentState];
                      }
                      mapping = this.matchMappings[currentState];
                      lastIndex = index;
                      re = this.regExps[currentState];
                      re.lastIndex = index;
                  }
                  break;
              }

              if (value) {
                  if (typeof type == "string") {
                      if ((!rule || rule.merge !== false) && token.type === type) {
                          token.value += value;
                      } else {
                          if (token.type)
                              tokens.push(token);
                          token = {type: type, value: value};
                      }
                  } else if (type) {
                      if (token.type)
                          tokens.push(token);
                      token = {type: null, value: ""};
                      for (var i = 0; i < type.length; i++)
                          tokens.push(type[i]);
                  }
              }

              if (lastIndex == line.length)
                  break;

              lastIndex = index;

              if (tokens.length > MAX_TOKEN_COUNT) {
                  // chrome doens't show contents of text nodes with very long text
                  while (lastIndex < line.length) {
                      if (token.type)
                          tokens.push(token);
                      token = {
                          value: line.substring(lastIndex, lastIndex += 2000),
                          type: "overflow"
                      };
                  }
                  currentState = "start";
                  stack = [];
                  break;
              }
          }

          if (token.type)
              tokens.push(token);
          
          if (stack.length > 1) {
              if (stack[0] !== currentState)
                  stack.unshift(currentState);
          }
          return {
              tokens : tokens,
              state : stack.length ? stack : currentState
          };
      };

  }).call(Tokenizer.prototype);

  // Token conversion.
  // See <https://github.com/ajaxorg/ace/wiki/Creating-or-Extending-an-Edit-Mode#common-tokens>
  // This is not an exact match nor the best match that can be made.
  var tokenFromAceToken = {
    empty: null,
    text: null,

    // Keyword
    keyword: 'keyword',
      control: 'keyword',
      operator: 'operator',

    // Constants
    constant: 'atom',
      numeric: 'number',
      character: 'atom',
        escape: 'atom',

    // Variables
    variable: 'variable',
    parameter: 'variable-3',
    language: 'variable-2',  // Python's `self` uses that.

    // Comments
    comment: 'comment',
      line: 'comment',
        'double-slash': 'comment',
        'double-dash': 'comment',
        'number-sign': 'comment',
        percentage: 'comment',
      block: 'comment',
        documentation: 'comment',

    // String
    string: 'string',
      quoted: 'string',
        single: 'string',
        double: 'string',
        triple: 'string',
      unquoted: 'string',
      interpolated: 'string',
      regexp: 'string-2',

    meta: 'meta',
    literal: 'qualifier',
    support: 'builtin',

    // Markup
    markup: 'tag',
    underline: 'link',
    link: 'link',
    bold: 'strong',
    heading: 'header',
    italic: 'em',
    list: 'variable-2',
    numbered: 'variable-2',
    unnumbered: 'variable-2',
    quote: 'quote',
    raw: 'variable-2',  // Markdown's raw block uses that.

    // Invalid
    invalid: 'error',
    illegal: 'invalidchar',
    deprecated: 'error'
  };

  // Takes a list of Ace tokens, returns a (string) CodeMirror token.
  var cmTokenFromAceTokens = function(tokens) {
    var token = null;
    for (var i = 0; i < tokens.length; i++) {
      // Find the most specific token.
      if (tokenFromAceToken[tokens[i]] !== undefined) {
        token = tokenFromAceToken[tokens[i]];
      }
    }
    return token;
  };

  // Consume a token from plannedTokens.
  var consumeToken = function(stream, state) {
    var plannedToken = state.plannedTokens.shift();
    if (plannedToken === undefined) {
      return null;
    }
    stream.match(plannedToken.value);
    var tokens = plannedToken.type.split('.');
    return cmTokenFromAceTokens(tokens);
  };

  var matchToken = function(stream, state) {
    // Anormal start: we already have planned tokens to consume.
    if (state.plannedTokens.length > 0) {
      return consumeToken(stream, state);
    }

    // Normal start.
    var currentState = state.current;
    var currentLine = stream.match(/.*$/, false)[0];
    var tokenized = tokenizer.getLineTokens(currentLine, currentState);
    // We got a {tokens, state} object.
    // Each token is a {value, type} object.
    state.plannedTokens = tokenized.tokens;
    state.current = tokenized.state;

    // Consume a token.
    return consumeToken(stream, state);
  }

  // Initialize all state.
  var aceHighlightRules = new HighlightRules();
  var tokenizer = new Tokenizer(aceHighlightRules.$rules);

  return {
    startState: function() {
      return {
        current: 'start',
        // List of {value, type}, with type being an Ace token string.
        plannedTokens: []
      };
    },
    blankLine: function(state) { matchToken('', state); },
    token: matchToken
  };
});

CodeMirror.defineMIME("text/x-elixir", "elixir");

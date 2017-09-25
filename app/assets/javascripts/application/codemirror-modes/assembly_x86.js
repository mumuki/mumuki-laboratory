// Parts from Ace; see <https://raw.githubusercontent.com/ajaxorg/ace/master/LICENSE>
CodeMirror.defineMode("assembly_x86", function(cmCfg, modeCfg) {

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


  define("assembly_x86_highlight_rules", function(require, exports, module) {
    "use strict";

    var oop = require("../lib/oop");
    var TextHighlightRules = require("./text_highlight_rules").TextHighlightRules;

    var AssemblyX86HighlightRules = function() {
        // regexp must not have capturing parentheses. Use (?:) instead.
        // regexps are ordered -> the first match is used

        this.$rules = { start:
           [ { token: 'keyword.control.assembly',
               regex: '\\b(?:aaa|aad|aam|aas|adc|add|addpd|addps|addsd|addss|addsubpd|addsubps|aesdec|aesdeclast|aesenc|aesenclast|aesimc|aeskeygenassist|and|andpd|andps|andnpd|andnps|arpl|blendpd|blendps|blendvpd|blendvps|bound|bsf|bsr|bswap|bt|btc|btr|bts|cbw|cwde|cdqe|clc|cld|cflush|clts|cmc|cmov(?:n?e|ge?|ae?|le?|be?|n?o|n?z)|cmp|cmppd|cmpps|cmps|cnpsb|cmpsw|cmpsd|cmpsq|cmpss|cmpxchg|cmpxchg8b|cmpxchg16b|comisd|comiss|cpuid|crc32|cvtdq2pd|cvtdq2ps|cvtpd2dq|cvtpd2pi|cvtpd2ps|cvtpi2pd|cvtpi2ps|cvtps2dq|cvtps2pd|cvtps2pi|cvtsd2si|cvtsd2ss|cvts2sd|cvtsi2ss|cvtss2sd|cvtss2si|cvttpd2dq|cvtpd2pi|cvttps2dq|cvttps2pi|cvttps2dq|cvttps2pi|cvttsd2si|cvttss2si|cwd|cdq|cqo|daa|das|dec|div|divpd|divps|divsd|divss|dppd|dpps|emms|enter|extractps|f2xm1|fabs|fadd|faddp|fiadd|fbld|fbstp|fchs|fclex|fnclex|fcmov(?:n?e|ge?|ae?|le?|be?|n?o|n?z)|fcom|fcmop|fcompp|fcomi|fcomip|fucomi|fucomip|fcos|fdecstp|fdiv|fdivp|fidiv|fdivr|fdivrp|fidivr|ffree|ficom|ficomp|fild|fincstp|finit|fnint|fist|fistp|fisttp|fld|fld1|fldl2t|fldl2e|fldpi|fldlg2|fldln2|fldz|fldcw|fldenv|fmul|fmulp|fimul|fnop|fpatan|fprem|fprem1|fptan|frndint|frstor|fsave|fnsave|fscale|fsin|fsincos|fsqrt|fst|fstp|fstcw|fnstcw|fstenv|fnstenv|fsts|fnstsw|fsub|fsubp|fisub|fsubr|fsubrp|fisubr|ftst|fucom|fucomp|fucompp|fxam|fxch|fxrstor|fxsave|fxtract|fyl2x|fyl2xp1|haddpd|haddps|husbpd|hsubps|idiv|imul|in|inc|ins|insb|insw|insd|insertps|int|into|invd|invplg|invpcid|iret|iretd|iretq|lahf|lar|lddqu|ldmxcsr|lds|les|lfs|lgs|lss|lea|leave|lfence|lgdt|lidt|llgdt|lmsw|lock|lods|lodsb|lodsw|lodsd|lodsq|lsl|ltr|maskmovdqu|maskmovq|maxpd|maxps|maxsd|maxss|mfence|minpd|minps|minsd|minss|monitor|mov|movapd|movaps|movbe|movd|movq|movddup|movdqa|movdqu|movq2q|movhlps|movhpd|movhps|movlhps|movlpd|movlps|movmskpd|movmskps|movntdqa|movntdq|movnti|movntpd|movntps|movntq|movq|movq2dq|movs|movsb|movsw|movsd|movsq|movsd|movshdup|movsldup|movss|movsx|movsxd|movupd|movups|movzx|mpsadbw|mul|mulpd|mulps|mulsd|mulss|mwait|neg|not|or|orpd|orps|out|outs|outsb|outsw|outsd|pabsb|pabsw|pabsd|packsswb|packssdw|packusdw|packuswbpaddb|paddw|paddd|paddq|paddsb|paddsw|paddusb|paddusw|palignr|pand|pandn|pause|pavgb|pavgw|pblendvb|pblendw|pclmulqdq|pcmpeqb|pcmpeqw|pcmpeqd|pcmpeqq|pcmpestri|pcmpestrm|pcmptb|pcmptgw|pcmpgtd|pcmpgtq|pcmpistri|pcmpisrm|pextrb|pextrd|pextrq|pextrw|phaddw|phaddd|phaddsw|phinposuw|phsubw|phsubd|phsubsw|pinsrb|pinsrd|pinsrq|pinsrw|pmaddubsw|pmadddwd|pmaxsb|pmaxsd|pmaxsw|pmaxsw|pmaxub|pmaxud|pmaxuw|pminsb|pminsd|pminsw|pminub|pminud|pminuw|pmovmskb|pmovsx|pmovzx|pmuldq|pmulhrsw|pmulhuw|pmulhw|pmulld|pmullw|pmuludw|pop|popa|popad|popcnt|popf|popfd|popfq|por|prefetch|psadbw|pshufb|pshufd|pshufhw|pshuflw|pshufw|psignb|psignw|psignd|pslldq|psllw|pslld|psllq|psraw|psrad|psrldq|psrlw|psrld|psrlq|psubb|psubw|psubd|psubq|psubsb|psubsw|psubusb|psubusw|test|ptest|punpckhbw|punpckhwd|punpckhdq|punpckhddq|punpcklbw|punpcklwd|punpckldq|punpckldqd|push|pusha|pushad|pushf|pushfd|pxor|prcl|rcr|rol|ror|rcpps|rcpss|rdfsbase|rdgsbase|rdmsr|rdpmc|rdrand|rdtsc|rdtscp|rep|repe|repz|repne|repnz|roundpd|roundps|roundsd|roundss|rsm|rsqrps|rsqrtss|sahf|sal|sar|shl|shr|sbb|scas|scasb|scasw|scasd|set(?:n?e|ge?|ae?|le?|be?|n?o|n?z)|sfence|sgdt|shld|shrd|shufpd|shufps|sidt|sldt|smsw|sqrtpd|sqrtps|sqrtsd|sqrtss|stc|std|stmxcsr|stos|stosb|stosw|stosd|stosq|str|sub|subpd|subps|subsd|subss|swapgs|syscall|sysenter|sysexit|sysret|teset|ucomisd|ucomiss|ud2|unpckhpd|unpckhps|unpcklpd|unpcklps|vbroadcast|vcvtph2ps|vcvtp2sph|verr|verw|vextractf128|vinsertf128|vmaskmov|vpermilpd|vpermilps|vperm2f128|vtestpd|vtestps|vzeroall|vzeroupper|wait|fwait|wbinvd|wrfsbase|wrgsbase|wrmsr|xadd|xchg|xgetbv|xlat|xlatb|xor|xorpd|xorps|xrstor|xsave|xsaveopt|xsetbv|lzcnt|extrq|insertq|movntsd|movntss|vfmaddpd|vfmaddps|vfmaddsd|vfmaddss|vfmaddsubbpd|vfmaddsubps|vfmsubaddpd|vfmsubaddps|vfmsubpd|vfmsubps|vfmsubsd|vfnmaddpd|vfnmaddps|vfnmaddsd|vfnmaddss|vfnmsubpd|vfnmusbps|vfnmusbsd|vfnmusbss|cvt|xor|cli|sti|hlt|nop|lock|wait|enter|leave|ret|loop(?:n?e|n?z)?|call|j(?:mp|n?e|ge?|ae?|le?|be?|n?o|n?z))\\b',
               caseInsensitive: true },
             { token: 'variable.parameter.register.assembly',
               regex: '\\b(?:CS|DS|ES|FS|GS|SS|RAX|EAX|RBX|EBX|RCX|ECX|RDX|EDX|RCX|RIP|EIP|IP|RSP|ESP|SP|RSI|ESI|SI|RDI|EDI|DI|RFLAGS|EFLAGS|FLAGS|R8-15|(?:Y|X)MM(?:[0-9]|10|11|12|13|14|15)|(?:A|B|C|D)(?:X|H|L)|CR(?:[0-4]|DR(?:[0-7]|TR6|TR7|EFER)))\\b',
               caseInsensitive: true },
             { token: 'constant.character.decimal.assembly',
               regex: '\\b[0-9]+\\b' },
             { token: 'constant.character.hexadecimal.assembly',
               regex: '\\b0x[A-F0-9]+\\b',
               caseInsensitive: true },
             { token: 'constant.character.hexadecimal.assembly',
               regex: '\\b[A-F0-9]+h\\b',
               caseInsensitive: true },
             { token: 'string.assembly', regex: /'([^\\']|\\.)*'/ },
             { token: 'string.assembly', regex: /"([^\\"]|\\.)*"/ },
             { token: 'support.function.directive.assembly',
               regex: '^\\[',
               push:
                [ { token: 'support.function.directive.assembly',
                    regex: '\\]$',
                    next: 'pop' },
                  { defaultToken: 'support.function.directive.assembly' } ] },
             { token:
                [ 'support.function.directive.assembly',
                  'support.function.directive.assembly',
                  'entity.name.function.assembly' ],
               regex: '(^struc)( )([_a-zA-Z][_a-zA-Z0-9]*)' },
             { token: 'support.function.directive.assembly',
               regex: '^endstruc\\b' },
            { token:
                [ 'support.function.directive.assembly',
                  'entity.name.function.assembly',
                  'support.function.directive.assembly',
                  'constant.character.assembly' ],
               regex: '^(%macro )([_a-zA-Z][_a-zA-Z0-9]*)( )([0-9]+)' },
             { token: 'support.function.directive.assembly',
               regex: '^%endmacro' },
             { token:
                [ 'text',
                  'support.function.directive.assembly',
                  'text',
                  'entity.name.function.assembly' ],
               regex: '(\\s*)(%define|%xdefine|%idefine|%undef|%assign|%defstr|%strcat|%strlen|%substr|%00|%0|%rotate|%rep|%endrep|%include|\\$\\$|\\$|%unmacro|%if|%elif|%else|%endif|%(?:el)?ifdef|%(?:el)?ifmacro|%(?:el)?ifctx|%(?:el)?ifidn|%(?:el)?ifidni|%(?:el)?ifid|%(?:el)?ifnum|%(?:el)?ifstr|%(?:el)?iftoken|%(?:el)?ifempty|%(?:el)?ifenv|%pathsearch|%depend|%use|%push|%pop|%repl|%arg|%stacksize|%local|%error|%warning|%fatal|%line|%!|%comment|%endcomment|__NASM_VERSION_ID__|__NASM_VER__|__FILE__|__LINE__|__BITS__|__OUTPUT_FORMAT__|__DATE__|__TIME__|__DATE_NUM__|_TIME__NUM__|__UTC_DATE__|__UTC_TIME__|__UTC_DATE_NUM__|__UTC_TIME_NUM__|__POSIX_TIME__|__PASS__|ISTRUC|AT|IEND|BITS 16|BITS 32|BITS 64|USE16|USE32|__SECT__|ABSOLUTE|EXTERN|GLOBAL|COMMON|CPU|FLOAT)\\b( ?)((?:[_a-zA-Z][_a-zA-Z0-9]*)?)',
               caseInsensitive: true },
              { token: 'support.function.directive.assembly',
               regex: '\\b(?:d[bwdqtoy]|res[bwdqto]|equ|times|align|alignb|sectalign|section|ptr|byte|word|dword|qword|incbin)\\b',
               caseInsensitive: true },
             { token: 'entity.name.function.assembly', regex: '^\\s*%%[\\w.]+?:$' },
             { token: 'entity.name.function.assembly', regex: '^\\s*%\\$[\\w.]+?:$' },
             { token: 'entity.name.function.assembly', regex: '^[\\w.]+?:' },
             { token: 'entity.name.function.assembly', regex: '^[\\w.]+?\\b' },
             { token: 'comment.assembly', regex: ';.*$' } ]
        };

        this.normalizeRules();
    };

    AssemblyX86HighlightRules.metaData = { fileTypes: [ 'asm' ],
          name: 'Assembly x86',
          scopeName: 'source.assembly' };


    oop.inherits(AssemblyX86HighlightRules, TextHighlightRules);

    exports.AssemblyX86HighlightRules = AssemblyX86HighlightRules;
    });


  // Ace highlight rules function imported below.
  var HighlightRules = require("assembly_x86_highlight_rules").AssemblyX86HighlightRules;



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

CodeMirror.defineMIME("text/x-assembly_x86", "assembly_x86");
CodeMirror.defineMIME("text/x-qsim", "assembly_x86");
CodeMirror.defineMIME("qsim", "assembly_x86");

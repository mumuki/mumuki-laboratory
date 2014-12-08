/*  Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        J.Wielemaker@uva.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2010, University of Amsterdam

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

    As a special exception, if you link this library with other files,
    compiled with a Free Software compiler, to produce an executable, this
    library does not by itself cause the resulting executable to be covered
    by the GNU General Public License. This exception does not however
    invalidate any other reasons why the executable file might be covered by
    the GNU General Public License.
*/

:- module(unicode,
	  [ unicode_property/2,		% ?Code, ?Property
	    unicode_map/3,		% +In, -Out, +Options
	    unicode_nfd/2,		% +In, -Out
	    unicode_nfc/2,		% +In, -Out
	    unicode_nfkd/2,		% +In, -Out
	    unicode_nfkc/2		% +In, -Out
	  ]).

:- use_foreign_library(foreign(unicode4pl)).

/** <module> Unicode string handling

This       library       is       a       wrapper       around       the
[[utf8proc][http://www.public-software-group.org/utf8proc]]     library,
providing  information  about   Unicode    code-points   and  performing
operations  (mappings)  on  Unicode  atoms.  The  central  predicate  is
unicode_map/3, mapping a Unicode atom to   another  Unicode atom using a
sequence of operations.  The   predicates  unicode_nfd/2, unicode_nfc/2,
unicode_nfkd/2 and unicode_nfkc/2 implement the   four  standard Unicode
normalization forms.

Lump handling:

==
U+0020      <-- all space characters (general category Zs)
U+0027  '   <-- left/right single quotation mark U+2018..2019,
                modifier letter apostrophe U+02BC,
                modifier letter vertical line U+02C8
U+002D  -   <-- all dash characters (general category Pd),
                minus U+2212
U+002F  /   <-- fraction slash U+2044,
                division slash U+2215
U+003A  :   <-- ratio U+2236
U+003C  <   <-- single left-pointing angle quotation mark U+2039,
                left-pointing angle bracket U+2329,
                left angle bracket U+3008
U+003E  >   <-- single right-pointing angle quotation mark U+203A,
                right-pointing angle bracket U+232A,
                right angle bracket U+3009
U+005C  \   <-- set minus U+2216
U+005E  ^   <-- modifier letter up arrowhead U+02C4,
                modifier letter circumflex accent U+02C6,
                caret U+2038,
                up arrowhead U+2303
U+005F  _   <-- all connector characters (general category Pc),
                modifier letter low macron U+02CD
U+0060  `   <-- modifier letter grave accent U+02CB
U+007C  |   <-- divides U+2223
U+007E  ~   <-- tilde operator U+223C
==

@see http://www.public-software-group.org/utf8proc
*/

system:goal_expansion(unicode_map(In, Out, Options),
		      unicode_map(In, Out, Mask)) :-
	is_list(Options),
	unicode_option_mask(Options, Mask).

%%	unicode_map(+In, -Out, +Options) is det.
%
%	Perform unicode normalization operations.  Options is a list
%	of operations.  Defined operations are:
%
%	    * stable
%	    Unicode Versioning Stability has to be respected.
%	    * compat
%	    Compatiblity decomposition (i.e. formatting information is lost)
%	    * compose
%	    Return a result with composed characters.
%	    * decompose
%	    Return a result with decomposed characters.
%	    * ignore
%	    Strip "default ignorable characters"
%	    * rejectna
%	    Return an error, if the input contains unassigned code
%	    points.
%	    * nlf2ls
%	    Indicating that NLF-sequences (LF, CRLF, CR, NEL) are
%           representing a line break, and should be converted to the
%           unicode character for line separation (LS).
%           * nlf2ps
%           Indicating that NLF-sequences are representing a paragraph
%           break, and should be converted to the unicode character for
%           paragraph separation (PS).
%           * nlf2lf
%           Indicating that the meaning of NLF-sequences is unknown.
%           * stripcc
%           Strips and/or convers control characters.
%           NLF-sequences are transformed into space, except if one of
%           the NLF2LS/PS/LF options is given.
%           HorizontalTab (HT) and FormFeed (FF) are treated as a
%           NLF-sequence in this case.
%           All other control characters are simply removed.
%           * casefold
%           Performs unicode case folding, to be able to do a
%           case-insensitive string comparison.
%           * charbound
%           Inserts 0xFF bytes at the beginning of each sequence which
%           is representing a single grapheme cluster (see UAX#29).
%           * lump
%           (e.g. HYPHEN U+2010 and MINUS U+2212 to ASCII "-").
%           (See module header for details.)
%           If NLF2LF is set, this includes a transformation of
%           paragraph and line separators to ASCII line-feed (LF).
%           * stripmark
%           Strips all character markings
%           (non-spacing, spacing and enclosing) (i.e. accents)
%           NOTE: this option works only with =compose= or =decompose=.

%%	unicode_nfd(+In, -Out) is det.
%
%	Characters are decomposed by canonical equivalence.

unicode_nfd(In, Out) :-
	unicode_map(In, Out, [stable,decompose]).

%%	unicode_nfc(+In, -Out) is det.
%
%	Characters are decomposed  and  then   recomposed  by  canonical
%	equivalence. It is possible for  the   result  to be a different
%	sequence of characters  than  the  original.
%
%	@see http://en.wikipedia.org/wiki/Unicode_equivalence#Normal_forms

unicode_nfc(In, Out) :-
	unicode_map(In, Out, [stable,compose]).

%%	unicode_nfkd(+In, -Out) is det.
%
%	Characters are decomposed by compatibility equivalence.

unicode_nfkd(In, Out) :-
	unicode_map(In, Out, [stable,decompose,compat]).

%%	unicode_nfkc(+In, -Out) is det.
%
%	Characters are decomposed  by   compatibility  equivalence, then
%	recomposed by canonical equivalence.

unicode_nfkc(In, Out) :-
	unicode_map(In, Out, [stable,compose,compat]).


%%	unicode_property(?Char, ?Property) is nondet.
%
%	True if Property is defined for Char.  Property is a term
%	Name(Value).  Defined property-names are:
%
%	    * category(atom)
%	    Unicode code category of Char. This is   one  of Cc, Cf, Cn,
%	    Co, Cs, Ll, Lm, Lo, Lt, Lu, Mc,  Me, Mn, Nd, Nl, No, Pc, Pd,
%	    Pe, Pf, Pi, Po, Ps, Sc, Sk, Sm, So, Zl, Zp, Zs. When
%	    testing, a single letter stands for all its subcategories.
%	    E.g. to test form a letter, you can use
%
%	        ==
%	        unicode_property(C, category('L'))
%	        ==
%
%	    * combining_class(integer)
%	    * bidi_class(atom)
%	    * decomp_type(atom)
%	    * decomp_mapping(list(code))
%	    * bidi_mirrored(bool)
%	    * uppercase_mapping(code)
%	    * lowercase_mapping(code)
%	    * titlecase_mapping(code)
%	    * comb1st_index(code)
%	    * comb2nd_index(code)
%	    * comp_exclusion(bool)
%	    * ignorable(bool)
%	    * control_boundary(bool)
%	    * extend(bool)
%	    * casefold_mapping(list(code))
%
%	@tbd Complete documentation

unicode_property(Code, Property) :-
	nonvar(Code), nonvar(Property), !,
	'$unicode_property'(Code, Property).
unicode_property(Code, Property) :-
	nonvar(Code), !,
	property(Property),
	'$unicode_property'(Code, Property).
unicode_property(Code, Property) :-
	var(Code), !,
	between(0, 0x10ffff, Code),
	property(Property),
	'$unicode_property'(Code, Property).

property(category(_)).
property(combining_class(_)).
property(bidi_class(_)).
property(decomp_type(_)).
property(decomp_mapping(_)).
property(bidi_mirrored(_)).
property(uppercase_mapping(_)).
property(lowercase_mapping(_)).
property(titlecase_mapping(_)).
property(comb1st_index(_)).
property(comb2nd_index(_)).
property(comp_exclusion(_)).
property(ignorable(_)).
property(control_boundary(_)).
property(extend(_)).
property(casefold_mapping(_)).

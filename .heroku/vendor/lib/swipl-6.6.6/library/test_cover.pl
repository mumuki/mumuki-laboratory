/*  Part of SWI-Prolog

    Author:        Jan Wielemaker
    E-mail:        J.Wielemaker@vu.nl
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2006-2012, University of Amsterdam
			      VU University Amsterdam

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

:- module(prolog_cover,
	  [ show_coverage/1		% :Goal
	  ]).
:- use_module(library(ordsets)).

:- set_prolog_flag(generate_debug_info, false).

/** <module> Clause cover analysis

The purpose of this module is to find which part of the program has been
use by a certain goal. Usage is defined   in  terms of clauses that have
fired, seperated in clauses that  succeeded   at  least once and clauses
that failed on each occasion.

This module relies on the  SWI-Prolog   tracer  hooks. It modifies these
hooks and collects the results, after   which  it restores the debugging
environment.  This has some limitations:

	* The performance degrades significantly (about 10 times)
	* It is not possible to use the debugger during coverage analysis
	* The cover analysis tool is currently not thread-safe.

The result is  represented  as  a   list  of  clause-references.  As the
references to clauses of dynamic predicates  cannot be guaranteed, these
are omitted from the result.

@bug	Relies heavily on SWI-Prolog internals. We have considered using
	a meta-interpreter for this purpose, but it is nearly impossible
	to do 100% complete meta-interpretation of Prolog.  Example
	problem areas include handling cuts in control-structures
	and calls from non-interpreted meta-predicates.
@tbd	Provide detailed information organised by predicate.  Possibly
	annotate the source with coverage information.
*/


:- dynamic
	entered/1,			% clauses entered
	exited/1.			% clauses completed

:- meta_predicate
	show_coverage(0).

%%	show_coverage(:Goal)
%
%	Report on coverage by Goal.  Goal is executed as in once/1.

show_coverage(Goal) :-
	setup_call_cleanup(
	    setup_trace(State),
	    once(Goal),
	    cleanup_trace(State)).

setup_trace(state(Visible, Leash, Ref)) :-
	asserta((user:prolog_trace_interception(Port, Frame, _, continue) :-
			prolog_cover:assert_cover(Port, Frame)), Ref),
	port_mask([unify,exit], Mask),
	'$visible'(Visible, Mask),
	'$leash'(Leash, Mask),
	trace.

port_mask([], 0).
port_mask([H|T], Mask) :-
	port_mask(T, M0),
	'$syspreds':port_name(H, Bit),
	Mask is M0 \/ Bit.

cleanup_trace(state(Visible, Leash, Ref)) :-
	nodebug,
	'$visible'(_, Visible),
	'$leash'(_, Leash),
	erase(Ref),
	covered(Succeeded, Failed),
	file_coverage(Succeeded, Failed).


%%	assert_cover(+Port, +Frame) is det.
%
%	Assert coverage of the current clause. We monitor two ports: the
%	_unify_ port to see which  clauses   we  entered, and the _exit_
%	port to see which completed successfully.

assert_cover(unify, Frame) :-
	running_static_pred(Frame),
	prolog_frame_attribute(Frame, clause, Cl), !,
	assert_entered(Cl).
assert_cover(exit, Frame) :-
	running_static_pred(Frame),
	prolog_frame_attribute(Frame, clause, Cl), !,
	assert_exited(Cl).
assert_cover(_, _).

%%	running_static_pred(+Frame) is semidet.
%
%	True if Frame is not running a dynamic predicate.

running_static_pred(Frame) :-
	prolog_frame_attribute(Frame, goal, Goal),
	\+ predicate_property(Goal, dynamic).

%%	assert_entered(+Ref) is det.
%%	assert_exited(+Ref) is det.
%
%	Add Ref to the set of entered or exited	clauses.

assert_entered(Cl) :-
	entered(Cl), !.
assert_entered(Cl) :-
	assert(entered(Cl)).

assert_exited(Cl) :-
	exited(Cl), !.
assert_exited(Cl) :-
	assert(exited(Cl)).

%%	covered(+Ref, +VisibleMask, +LeashMask, -Succeeded, -Failed) is	det.
%
%	Restore state and collect failed and succeeded clauses.

covered(Succeeded, Failed) :-
	findall(Cl, (entered(Cl), \+exited(Cl)), Failed0),
	findall(Cl, retract(exited(Cl)), Succeeded0),
	retractall(entered(Cl)),
	sort(Failed0, Failed),
	sort(Succeeded0, Succeeded).


		 /*******************************
		 *	     REPORTING		*
		 *******************************/

%%	file_coverage(+Succeeded, +Failed) is det.
%
%	Write a report on  the  clauses   covered  organised  by file to
%	current output.

file_coverage(Succeeded, Failed) :-
	format('~N~n~`=t~78|~n'),
	format('~tCoverage by File~t~78|~n'),
	format('~`=t~78|~n'),
	format('~w~t~w~64|~t~w~72|~t~w~78|~n',
	       ['File', 'Clauses', '%Cov', '%Fail']),
	format('~`=t~78|~n'),
	forall(source_file(File),
	       file_coverage(File, Succeeded, Failed)),
	format('~`=t~78|~n').

file_coverage(File, Succeeded, Failed) :-
	findall(Cl, clause_source(Cl, File, _), Clauses),
	sort(Clauses, All),
	(   ord_intersect(All, Succeeded)
	->  true
	;   ord_intersect(All, Failed)
	), !,
	ord_intersection(All, Failed, FailedInFile),
	ord_intersection(All, Succeeded, SucceededInFile),
	ord_subtract(All, SucceededInFile, UnCov1),
	ord_subtract(UnCov1, FailedInFile, Uncovered),
	length(All, AC),
	length(Uncovered, UC),
	length(FailedInFile, FC),
	CP is 100-100*UC/AC,
	FCP is 100*FC/AC,
	summary(File, 56, SFile),
	format('~w~t ~D~64| ~t~1f~72| ~t~1f~78|~n', [SFile, AC, CP, FCP]).
file_coverage(_,_,_).


summary(Atom, MaxLen, Summary) :-
	atom_length(Atom, Len),
	(   Len < MaxLen
	->  Summary = Atom
	;   SLen is MaxLen - 5,
	    sub_atom(Atom, _, SLen, 0, End),
	    atom_concat('...', End, Summary)
	).


%%	clause_source(+Clause, -File, -Line) is det.
%%	clause_source(-Clause, +File, -Line) is det.

clause_source(Clause, File, Line) :-
	nonvar(Clause), !,
	clause_property(Clause, file(File)),
	clause_property(Clause, line_count(Line)).
clause_source(Clause, File, Line) :-
	source_file(Pred, File),
	\+ predicate_property(Pred, multifile),
	nth_clause(Pred, _Index, Clause),
	clause_property(Clause, line_count(Line)).
clause_source(Clause, File, Line) :-
	Pred = _:_,
	predicate_property(Pred, multifile),
	nth_clause(Pred, _Index, Clause),
	clause_property(Clause, file(File)),
	clause_property(Clause, line_count(Line)).

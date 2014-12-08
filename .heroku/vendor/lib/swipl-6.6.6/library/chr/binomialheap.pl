/*  $Id$

    Part of CHR (Constraint Handling Rules)

    Author:        Tom Schrijvers
    E-mail:        Tom.Schrijvers@cs.kuleuven.be
    WWW:           http://www.swi-prolog.org
    Copyright (C): 2003-2004, K.U. Leuven

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
    of the License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

    As a special exception, if you link this library with other files,
    compiled with a Free Software compiler, to produce an executable, this
    library does not by itself cause the resulting executable to be covered
    by the GNU General Public License. This exception does not however
    invalidate any other reasons why the executable file might be covered by
    the GNU General Public License.
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Binomial Heap imlementation based on
%
%	Functional Binomial Queues
%	James F. King
%	University of Glasgow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- module(binomialheap,
	[
		empty_q/1,
		insert_q/3,
		insert_list_q/3,
		delete_min_q/3,
		find_min_q/2
	]).

:- use_module(library(lists),[reverse/2]).

% data Tree a = Node a [Tree a]
% type BinQueue a = [Maybe (Tree a)]
% data Maybe a = Zero | One a
% type Item = (Entry,Key)

key(_-Key,Key).

empty_q([]).

meld_q(P,Q,R) :-
	meld_qc(P,Q,zero,R).

meld_qc([],Q,zero,Q) :- !.
meld_qc([],Q,C,R) :- !,
	meld_q(Q,[C],R).
meld_qc(P,[],C,R) :- !,
	meld_qc([],P,C,R).
meld_qc([zero|Ps],[zero|Qs],C,R) :- !,
	R = [C | Rs],
	meld_q(Ps,Qs,Rs).
meld_qc([one(node(X,Xs))|Ps],[one(node(Y,Ys))|Qs],C,R) :- !,
	key(X,KX),
	key(Y,KY),
	( KX < KY ->
		T = node(X,[node(Y,Ys)|Xs])
	;
		T = node(Y,[node(X,Xs)|Ys])
	),
	R = [C|Rs],
	meld_qc(Ps,Qs,one(T),Rs).
meld_qc([P|Ps],[Q|Qs],C,Rs) :-
	meld_qc([Q|Ps],[C|Qs],P,Rs).

insert_q(Q,I,NQ) :-
	meld_q([one(node(I,[]))],Q,NQ).

insert_list_q([],Q,Q).
insert_list_q([I|Is],Q,NQ) :-
	insert_q(Q,I,Q1),
	insert_list_q(Is,Q1,NQ).

min_tree([T|Ts],MT) :-
	min_tree_acc(Ts,T,MT).

min_tree_acc([],MT,MT).
min_tree_acc([T|Ts],Acc,MT) :-
	least(T,Acc,NAcc),
	min_tree_acc(Ts,NAcc,MT).

least(zero,T,T) :- !.
least(T,zero,T) :- !.
least(one(node(X,Xs)),one(node(Y,Ys)),T) :-
	key(X,KX),
	key(Y,KY),
	( KX < KY ->
		T = one(node(X,Xs))
	;
		T = one(node(Y,Ys))
	).

remove_tree([],_,[]).
remove_tree([T|Ts],I,[NT|NTs]) :-
	( T == zero ->
		NT = T
	;
		T = one(node(X,_)),
		( X == I ->
			NT = zero
		;
			NT = T
		)
	),
	remove_tree(Ts,I,NTs).

delete_min_q(Q,NQ,Min) :-
	min_tree(Q,one(node(Min,Ts))),
	remove_tree(Q,Min,Q1),
	reverse(Ts,RTs),
	make_ones(RTs,Q2),
	meld_q(Q2,Q1,NQ).

make_ones([],[]).
make_ones([N|Ns],[one(N)|RQ]) :-
	make_ones(Ns,RQ).

find_min_q(Q,I) :-
	min_tree(Q,one(node(I,_))).



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

:- module(a_star,
	[
		a_star/4
	]).

:- use_module(binomialheap).

:- use_module(find).

:- use_module(library(dialect/hprolog)).

a_star(DataIn,FinalData,ExpandData,DataOut) :-
	a_star_node(DataIn,0,InitialNode),
	empty_q(NewQueue),
	insert_q(NewQueue,InitialNode,Queue),
	a_star_aux(Queue,FinalData,ExpandData,EndNode),
	a_star_node(DataOut,_,EndNode).

a_star_aux(Queue,FinalData,ExpandData,EndNode) :-
	delete_min_q(Queue,Queue1,Node),
	( final_node(FinalData,Node) ->
		Node = EndNode
	;
		expand_node(ExpandData,Node,Nodes),
		insert_list_q(Nodes,Queue1,NQueue),
		a_star_aux(NQueue,FinalData,ExpandData,EndNode)
	).

final_node(D^Call,Node) :-
	a_star_node(Data,_,Node),
	term_variables(Call,Vars),
	chr_delete(Vars,D,DVars),
	copy_term(D^Call-DVars,Data^NCall-DVars),
	call(NCall).

expand_node(D^Ds^C^Call,Node,Nodes) :-
	a_star_node(Data,Score,Node),
	term_variables(Call,Vars),
	chr_delete(Vars,D,DVars0),
	chr_delete(DVars0,Ds,DVars1),
	chr_delete(DVars1,C,DVars),
	copy_term(D^Ds^C^Call-DVars,Data^EData^Cost^NCall-DVars),
	term_variables(Node,NVars,DVars),
	find_with_var_identity(ENode,NVars,(NCall,EScore is Cost + Score,a_star:a_star_node(EData,EScore,ENode)),Nodes).

a_star_node(Data,Score,Data-Score).

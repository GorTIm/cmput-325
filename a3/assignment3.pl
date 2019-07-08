/*Cmput 325 Winter 2019 Assignment 3
 CCID 1446915 Student name Weihao Han
*/

/*----------------------------------------------------
Question 1

alternate(+L1, +L2, ?L)
L is the result of taking elements from L1 and L2 
alternately, and putting them into L. 
If one of L1 or L2 is longer than the other, 
then the extra elements go to the end. 
------------------------------------------------------*/

alternate([],[],[]).
alternate([],[B|R2],L):- append([],[B],DoneList), alternate([],R2,LRest), append(DoneList,LRest,L). 
alternate([A|R1],[],L) :- append([A],[],DoneList), alternate(R1,[],LRest), append(DoneList,LRest,L).
alternate([A|R1],[B|R2],L) :- append([A],[B],DoneList), alternate(R1,R2,LRest), append(DoneList,LRest,L).


/*------------------------------------------------------------------------------------------------------
Question 2

counti(+L, ?N)
L is a fully instantiated, possibly nested list of integers and atoms. 
N is the count of how many integers appear anywhere within L. 
N can be given, or a variable. See the examples. Note that atom(X) is false for integers X
-------------------------------------------------------------------------------------------------------*/


counti([],0).
counti([A|RestList],N):- atomic(A), split_count(A,N1), counti(RestList,N2), N is N1+N2.
counti([A|RestList],N):- counti(A,N1),counti(RestList,N2),N is N1+N2.

/*------------------------------------------------------------------------------------------------------
split_count(+A, ?N)
A is an atom or integer. This function is a simple chekc function of type of input.
-------------------------------------------------------------------------------------------------------*/
split_count(A,N):- atom(A),N is 0.
split_count(A,N):- integer(A),N is 1 .


/*------------------------------------------------------------------------------------------------------
Question 3

umem(-X,+L)
Unlike the built-in predicate member,umem should generate repeated arguments in a list 
only once: the first time they appear in the list
-------------------------------------------------------------------------------------------------------*/


umem(X, [X|_]).
umem(X, [P|L]) :- umem(X, L),X\==P .



/*------------------------------------------------------------------------------------------------------
Question 4.1

required(+C,?L)
C is a given course, and L is the list of all courses which are direct prerequisites, 
or are indirectly required because they are prerequisite for other required courses. 
L should be sorted in the same order as in the facts database.
-------------------------------------------------------------------------------------------------------*/

/*is_prereq(+C1,+C2)
Check whether C1 is the course required to take C2.
*/
 
is_prereq(Pre,C):- prerequisite(Pre,C).
is_prereq(Pre,C):- prerequisite(Pre,Medium),is_prereq(Medium,C).

/*course_order(?C1,+C2)
This function go through the database in the order of course, and then ask query on each course
whether it is the course required in order to take C2 
*/
course_order(Pre,C):-course(Pre),is_prereq(Pre,C).

required(C,L):- findall(Pre,course_order(Pre,C), FullList),findall(X, umem(X,FullList), L).


/*------------------------------------------------------------------------------------------------------
Question 4.2

can_take(+L,?C)
Here, L is a given list of courses that a student has already taken. 
If C is also given,then the predicate should check whether the student has all the required courses for C. 
If C is a variable, then with backtracking, the predicate should produce one course at a time 
that the student can take now. Courses can be in any order, but each course should be generated only once, 
and you should not return any courses that the student has already taken.
-------------------------------------------------------------------------------------------------------*/

%not_member(?X,+L) predicate in class 
not_member(_, []).
not_member(X, [Y|L]) :- X \== Y,not_member(X, L).

/* 
meet_all_pre(+L1,+L2)
This function check wheter all elements in L2 is also in L1.
In this question, L2 is the list of required courses of a course.
L1 is the list of courses the student have done.
*/
meet_all_pre(_,[]).
meet_all_pre(T,[F|Rest]):- member(F,T),meet_all_pre(T,Rest).


can_take(Taken_List,C):-course(C),not_member(C,Taken_List),required(C,
    Require_list),meet_all_pre(Taken_List,Require_list).

/*------------------------------------------------------------------------------------------------------
Question 4.3

in_cycle(+C,-Cycle)
The input is a course C. If there is a cyclic dependency between course prerequisites involving course C, 
then compute a cycle starting and ending with C, as follows: Return Cycle = [C1, C2, .., Cn-1, Cn], 
Such that C1 = Cn = C, and for all successive courses Ci, Ci+1 in the list, prerequisite(Ci, Ci+1) is a fact.

In case there is no cycle involving C, the query should return
false.

Test cases:
course(cmput325).
course(cmput175).
course(cmput201).
course(cmput204).
prerequisite(cmput204, cmput325).
prerequisite(cmput175, cmput201).
prerequisite(cmput175, cmput204).
prerequisite(cmput325, cmput175).

in_cycle(cmput325, Cycle).
Cycle = [cmput325, cmput175, cmput204, cmput325]

in_cycle(cmput175, Cycle).
Cycle = [cmput175, cmput204, cmput325, cmput175]

in_cycle(cmput204, Cycle).
Cycle = [cmput204, cmput325, cmput175, cmput204]

in_cycle(cmput201, Cycle).
false.
-------------------------------------------------------------------------------------------------------*/

%find_last(X,L) is a function to find the last element of a given list
find_last(X,[X]).
find_last(X,[_|Rest]):-find_last(X,Rest).

/*
find_cycle(+L1,?L2)

this function is used to check whether a cyclic dependency exists there for the given input list L1,
where the first element of L1 is a course C involved  in the dependency.
If L2 is also provided, it will evaluate whether a cyclic dependency exist and is same as L2.

Test cases:

?-find_cycle([cmput325, cmput175],L).
L = [cmput325, cmput175, cmput204, cmput325] ;
false.

?- find_cycle([cmput325, cmput175], [cmput325, cmput175, cmput204, cmput325]).
true 
*/
find_cycle([C|Rest],Cycle):-find_last(Descendent,[C|Rest]),C==Descendent,append([C|Rest], [], Cycle).
find_cycle([C|Rest],Cycle):-find_last(Descendent,[C|Rest]),C\==Descendent,prerequisite(Descendent,
    Sub_descendent),not_member(Sub_descendent,Rest), append([C|Rest], [Sub_descendent], 
    Current_List), find_cycle(Current_List,Cycle).


in_cycle(C,Cycle):-prerequisite(C,F),find_cycle([C,F],Cycle).
%% Tell prolog that we load definitions for course/1 and prerequisite/2
%% dynamically.
:- dynamic(course/1).
:- dynamic(prerequisite/2).

%% Consult the assignment.
:- [assignment3].

/* ---------------------------------------------------------
Tests for Question 1
--------------------------------------------------------- */
:- begin_tests(q1).

test('alternate 1', true(R == [1,a,2,b,3,c])) :-
    alternate([1,2,3],[a,b,c],R).
test('alternate 2', true(R == [1,a,2,b,c])) :-
    alternate([1,2],[a,b,c],R).
test('alternate 3', true(R == [1,a,b,c])) :-
    alternate([1],[a,b,c],R).
test('alternate 4', true(R == [])) :-
    alternate([],[],R).
test('alternate 5', true(R == [a,1,b,2,c,3])) :-
    alternate([a,b,c],[1,2,3],R).

:- end_tests(q1).

/* ---------------------------------------------------------
Question 2
--------------------------------------------------------- */
:- begin_tests(q2).

test('counti 1', all(N == [0])) :-
    counti([],N).
test('counti 2') :-
    counti([],0), !.
test('counti 3', all(N == [3])) :-
    counti([1,2,3],N).
test('counti 4', all(N == [13])) :-
    counti([[2],[1,2,3,4,5,6],2,[2,3],[1],2,7], N).
test('counti 5', all(N == [14])) :-
    counti([[1,2,[[[[3]]]],4,5],[6,7,8],[9,10,11],12,[3],4],N).
test('counti 6', all(N == [17])) :-
    counti([[1,2,2],[6,1,[],[[4]]],5,[8,1],[6,[5,[4]],12],7,1,3,6], N).
test('counti 7', all(N == [13])) :-
    counti([k,[2],a,[a,d,1,b,2,v,c,3,4,5,c,v,x,s,6],2,a,d,[2,3,d,x],[d,d,1],2,f,7],N).
test('counti 8', all(N == [14])) :-
    counti([[1,2,3,a,f,v,4,t,5],[r,6,7,q,8],[9,10,e,e,11],12,f,[13,d],14],N).
test('counti 9', all(N == [17])) :-
    counti([[1,2,2,f,d,h],[6,1,[f],d,s,[[4]]],5,g,[8,1],[6,d,[5,[4]],d,12],7,1,r,3,t,6],N).

:- end_tests(q2).

/* ---------------------------------------------------------
Question 3
--------------------------------------------------------- */
:- begin_tests(q3).

test('umem 1', all(X == [])) :-
    umem(X, []).
test('umem 2', all(X == [a,b])) :-
    umem(X, [a,a,b]).
test('umem 3', all(X == [a,b,c,d,e,f])) :-
    umem(X, [a,b,c,a,d,c,b,a,e,f]).

:- end_tests(q3).

/* ---------------------------------------------------------
Tests for Question 4.1
--------------------------------------------------------- */
:- begin_tests(q4_1_miniDB).

test('required 1', true(L == [cmput175,cmput204])) :-
    required(cmput325, L).

:- end_tests(q4_1_miniDB).

:- begin_tests(q4_1_fullDB).

test('required 2', true(L == [cmput174, cmput175, cmput272])) :-
    required(cmput204, L).
test('required 3', true(L == [cmput174, cmput175, cmput201])) :-
    required(cmput229, L).
test('required 4', true(L == [cmput174, cmput175, cmput201, cmput204, cmput272, cmput340])) :-
    required(cmput306, L).
test('required 5', true(L == [cmput174, cmput175, cmput201, cmput301, cmput401])) :-
    required(cmput402, L).
test('required 6', true(L == [cmput174, cmput175, cmput201, cmput204, cmput272, cmput291, cmput301, cmput391])) :-
    required(cmput410, L).
test('required 7', true(L == [cmput174, cmput175, cmput201, cmput204, cmput206, cmput272, cmput306, cmput307, cmput340])) :-
    required(cmput414, L).
test('required 8', true(L == [cmput174, cmput175, cmput201, cmput204, cmput272, cmput340])) :-
    required(cmput428, L).

:- end_tests(q4_1_fullDB).

/* ---------------------------------------------------------
Tests for Question 4.2
--------------------------------------------------------- */
:- begin_tests(q4_2_miniDB).
test('can_take 1') :-
    findall(C,can_take([cmput175], C),L),
    permutation(L,[cmput201,cmput204]), !.
:- end_tests(q4_2_miniDB).

:- begin_tests(q4_2_fullDB).
test('can_take 2') :-
    findall(C,can_take([cmput174, cmput175, cmput201, cmput204, cmput229, cmput272, cmput325], C),L),
    permutation(L,[cmput101,cmput206,cmput210,cmput250,cmput275,cmput291,
                   cmput296,cmput297,cmput299,cmput300,cmput301,cmput304,
                   cmput313,cmput329,cmput333,cmput340,cmput350,cmput366,
                   cmput379,cmput396,cmput399,cmput400,cmput418,cmput419,
                   cmput429,cmput474,cmput495,cmput496,cmput497,cmput498,cmput499]), !.
:- end_tests(q4_2_fullDB).

/* ---------------------------------------------------------
Tests for Question 4.3
--------------------------------------------------------- */
:- begin_tests(q4_3_mini_cycleDB).
test('in_cycle 1', all(Cycle == [[cmput325, cmput175, cmput204, cmput325]])) :-
    in_cycle(cmput325, Cycle).
test('in_cycle 2', all(Cycle == [[cmput175, cmput204, cmput325, cmput175]])) :-
    in_cycle(cmput175, Cycle).
test('in_cycle 3', all(Cycle == [[cmput204, cmput325, cmput175, cmput204]])) :-
    in_cycle(cmput204, Cycle).
test('in_cycle 4', all(Cycle == [])) :-
    in_cycle(cmput201, Cycle).
:- end_tests(q4_3_mini_cycleDB).

:- begin_tests(q4_3_full_cycleDB).
test('in_cycle 5', all(Cycle == [[cmput174, cmput272, cmput174]])) :-
    in_cycle(cmput174, Cycle).
test('in_cycle 6', all(Cycle == [[cmput229, cmput429, cmput229]])) :-
    in_cycle(cmput229, Cycle).
test('in_cycle 7', all(Cycle == [[cmput272, cmput174, cmput272]])) :-
    in_cycle(cmput272, Cycle).
test('in_cycle 8', all(Cycle == [[cmput302, cmput302]])) :-
    in_cycle(cmput302, Cycle).
test('in_cycle 9', all(Cycle == [[cmput306, cmput340, cmput306]])) :-
    in_cycle(cmput306, Cycle).
test('in_cycle 10', all(Cycle == [[cmput340, cmput306, cmput340]])) :-
    in_cycle(cmput340, Cycle).
test('in_cycle 11', all(Cycle == [[cmput404, cmput404]])) :-
    in_cycle(cmput404, Cycle).
test('in_cycle 12', all(Cycle == [[cmput429, cmput229, cmput429]])) :-
    in_cycle(cmput429, Cycle).
test('in_cycle 13', all(Cycle == [])) :-
    in_cycle(cmput499, Cycle).
:- end_tests(q4_3_full_cycleDB).

/* ---------------------------------------------------------
Run tests: Uncomment tests you want to run.

For Question 4 tests, you must uncomment consult and the retracts as well.
--------------------------------------------------------- */
:- run_tests(q1).

:- run_tests(q2).

:- run_tests(q3).

:- [a3_miniDB_unit].
:- run_tests(q4_1_miniDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- [a3_fullDB_unit].
:- run_tests(q4_1_fullDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- [a3_miniDB_unit].
:- run_tests(q4_2_miniDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- [a3_fullDB_unit].
:- run_tests(q4_2_fullDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- [a3_mini_cycleDB_unit].
:- run_tests(q4_3_mini_cycleDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- [a3_full_cycleDB_unit].
:- run_tests(q4_3_full_cycleDB).
:- retractall(course(_)).
:- retractall(prerequisite(_,_)).

:- halt.

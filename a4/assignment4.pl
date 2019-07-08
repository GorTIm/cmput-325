/*Cmput 325 Winter 2019 Assignment 4
 CCID 1446915 Student name Weihao Han
*/

/*---------------------------------------------------------
Question 1

fourSquares(+N, [-S1, -S2, -S3, -S4])
Given any positive integer N greater than 0, 
fourSquares returns a list of integers [S1,S2,S3,S4] such that
N = S1*S1 + S2*S2 + S3*S3 + S4*S4.
In order to keep things nice and tidy, it is also required that 
S1 <= S2 <= S3 <= S4. Note that some of S1...S3 may be zero.
On backtracking, fourSquares should return all possible answers 
since there may be more than one solution. For example,

20 = 2*2 + 4*4 
and
20 = 1*1 + 1*1 + 3*3 + 3*3
----------------------------------------------------------*/

:- use_module(library(clpfd)).

fourSquares(N, [S1, S2, S3, S4]):- Vars=[S1, S2, S3, S4],Vars ins 0..N,
    S1 #=< S2,S2 #=< S3,S3 #=< S4,N #= S1*S1+S2*S2+S3*S3+S4*S4,label(Vars).



/*----------------------------------------------------------------------
Question 2

disarm(+Adivisions, +Bdivisions,-Solution)
Adivisions and Bdivisions are input lists containing the strength 
of each country's divisions(represented by integers), and Solution 
is an output list describing the successive dismantlements. 
Each element of Solution represents one dismantlement, 
where a dismantlement is a list containing two elements: 
the first element is a list of country A's dismantlements and the second 
is a list of country B's dismantlements.

For each dismantlement in Solution, the sum of A's dismantlements should
be equal to B's. One of element in the dismantlement should be 1 and 
the other should be 2. For example, suppose

Adivisions=[1, 3, 3, 4, 6, 10, 12]
Bdivisions=[3, 4, 7, 9, 16]

Then, 
Solution = [[[1,3],[4]], [[3,4],[7]], [[12],[3,9]], [[6,10],[16]]]

Finanlly,make sure that the total strength of one month's dismantlement 
is less than or equal to the total strength of next month's dismantlement.
For the above instance, 

3<4<7<12<16
-------------------------------------------------------------------------*/




/*-------------------------------------------------------------------------
find_sum_A(+A,+B,-Sum,-NextA,-NextB,-Return)

This function handle the case where sum of two elements in A is equal to 
one element in B. It takes two list A and B as input, and return the 
minimun sum of elements which meets requirement that they are not duplicated  
in List A and their sum is equal to an element in B. Besides, the newly 
generated lists where elements mentioned were opt out will be return as 
NextA and NextB.Finanlly, the partical solution will be given as Return.
-------------------------------------------------------------------------*/

find_sum_A(A,B,Sum,NextA,NextB,Return):-min_list(A, MinA),min_list(B, MinB),max_list(A, 
    MaxA),max_list(B, MaxB),VarList=[Var1,Var2],VarList ins MinA..MaxA, Var3 in MinB..MaxB,
    Var1+Var2#=Var3,labeling([min(Var1),min(Var2)],[Var1,Var2,Var3])
    ,member(Var1, A),selectchk(Var1, A, SubA),member(Var2,SubA),selectchk(Var2, SubA, NextA)
    ,member(Var3, B),selectchk(Var3, B, NextB)
    ,!,Sum is Var3,append([[VarList,[Var3]]],[],Return)
    .
/*-------------------------------------------------------------------------
find_sum_B(+A,+B,-Sum,-NextA,-NextB,-Return)

This function handle the case where sum of two elements in B is equal to 
one element in A. It takes two list A and B as input, and return the 
minimun sum of elements which meets requirement that they are not duplicated  
in List B and their sum is equal to an element in A. Besides, the newly 
generated lists where elements mentioned were opt out will be return as 
NextA and NextB.Finanlly, the partical solution will be given as Return.
-------------------------------------------------------------------------*/

find_sum_B(A,B,Sum,NextA,NextB,Return):-min_list(A, MinA),min_list(B, MinB),max_list(A, 
    MaxA),max_list(B, MaxB),VarList=[Var2,Var3],Var1 in MinA..MaxA, VarList ins MinB..MaxB,
    Var1#=Var2+Var3,labeling([min(Var2),min(Var3)],[Var1,Var2,Var3])
    ,member(Var1, A),selectchk(Var1, A, NextA),member(Var2,B),selectchk(Var2, B, SubB)
    ,member(Var3, SubB),selectchk(Var3, SubB, NextB)
    ,!,Sum is Var1,append([[[Var1],VarList]],[], Return)
    .

/*-------------------------------------------------------------------------
Disarm will try to check if input lists are empty(base case) firstly, and
return empty list if true. Otherwise, it will look for the minimum sum of 
two elements in A and that in B. Find the smaller sum and use the sub-lists
which comes from the find_sum predicate generate the smaller sum to do recursion call.
Once the recursion call return, append the sub-solution from find_sum to 
the result from recursive call. Use cut to control the flow of prolog and 
prevent further check on predicate with same name.

The three predicate handle three cases: 1. Both A and B could find 
available answer(there are two elements in A whose sum is equal to one 
element in B, and two elements in B whose sum is equal to a element in A)
and sum of elements in A are smaller.
2 The sum of elements in B are smaller or we can only find available answer
in B.
3 We can only find available answer in A 

-------------------------------------------------------------------------*/

disarm([],[],Solution):-append([],[],Solution).

disarm(A,B,Solution):-find_sum_A(A,B,Sum_1,NextA_1,NextB_1,Return_1),find_sum_B(A,B,Sum_2,
    _,_,_),Sum_1 =< Sum_2,!,disarm(NextA_1,NextB_1,SubSol),append(Return_1,SubSol,Solution).

disarm(A,B,Solution):- find_sum_B(A,B,_,NextA_2,
    NextB_2,Return_2),!,disarm(NextA_2,NextB_2,SubSol),append(Return_2,SubSol,Solution).

disarm(A,B,Solution):-find_sum_A(A,B,_,NextA_1,
    NextB_1,Return_1),disarm(NextA_1,NextB_1,SubSol),append(Return_1,SubSol,Solution).




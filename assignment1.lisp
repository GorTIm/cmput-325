; Cmput 325 Winter 2019 Assignment 1
; CCID 1446915 Student name Weihao Han

;QUESTION 1 issorted
"This function checks whether a given list of integers L is sorted in strictly increasing order. 
It returns T if L is sorted, and NIL otherwise. 
Lists with fewer than two elements are considered sorted 

Firstly check the size of list. If it was less tha two, return True. Otherwise, 
compare the 1st and 2nd elements.If the former one is greater than or equal to the latter,
return nil. If not, call issorted on the list which consist of all elements in L 
except the first element 
"

(defun issorted (L) 
    (if (null (cdr L)) (= 4 4) 
        (if (>= (car L) (cadr L)) nil (issorted (cdr L) )

)))


;QUESTION 2 numbers
"Given a nonnegative integer N, the function produce the list of all integers 
from 1 up to and including N

If the input number N is less than 1, then just return null.Otherwise, 
call numbers on N-1 which will return the list consist of integers from 1 to N-1,
and append this list to a list of only one element N
"

(defun numbers (N)
    (if (< N 1) NIL (append (numbers (- N 1)) (cons N () ) ))

)

;QUESTION 3 palindrome

"GetLast return the last element of the given list.
It will check if the input list is of size one. If so, return the only element on the list
by calling car on this list. Otherwise, call getLast on a sub-list which consist of all elements
except the 1st one in the input list. 
"
(defun getLast (L)
    (if (null (cdr L)) (car L) (getLast (cdr L) ) )


)

"OptoutLast create a new list by deleting the last element of the input list.
It will check if the input list is of size one.If so,it returns null.
Otherwise, it will construct a list by adding the 1st element of the input list and 
call OptoutLast on a sub-list of the input list, where the sub-list is the input list 
without the 1st element. Such recursive call will end until the sub-list if of length 1.
"
(defun optoutLast(L)
   (if (null (cdr L)) nil (cons (car L) (optoutLast (cdr L) ) ) )

)

"Palindrome checks if a given list L of atoms is a palindrome, 
i.e. it reads the same from the front and the back. 
It will check if the first and last element of the input list are the same.If not, return false. 
Otherwise, it will go further to if the input list is of size less
than 1. If so, it means that the checking procoss is done and the return true.
If not, call palindrome on a sub-list of input list where the 1st and last element were
opt out.
"
(defun palindrome (L) 
    (if (eq (car L) (getLast L))  
        (if (null (cdr L)) 
        T 
        (palindrome (optoutLast (cdr L) ) ))  
    nil )


)


;QUESTION 4

"Function replace1 replaces all instances of Atom1 by Atom2 in elements of List. 
Sublists would be left as they are; Anything inside a sublist would not be replaced.

The function will firstly check if the input list contains only one element. If so,
return the list directly. Otherwise, check whether the first element of the list is equal to
A1. If yes, replace A1 by A2 and call replace1 on the rest of input list.
If no, leave it as before and call replace1 on the rest of input list.
"
(defun replace1 (A1 A2 L) 
    (if (null (cdr L) )  L
        (if (eq A1 (car L) )  (cons A2 (replace1 A1 A2 (cdr L) ) )  
            (cons (car L) (replace1 A1 A2 (cdr L) ) ) 
        ) 
    )

)

"The function replace2 also replaces Atom1 by Atom2. 
However, this function replaces recursively in all sublists

The function will firstly check if the input list is an empty list, which is the terminal state.If so,
return the list directly.Otherwise,check whether the first element is an atom.If yes,
do the same thing as in replace1. If no, that means the first element of input list was also a list,
then call replace2 on the 1st element and the rest of input list seperately.
"

(defun replace2 (A1 A2 L)  
    (if (null (car L)) L 
        (cond ((atom (car L) ) (if (eq A1 (car L) )  (cons A2 (replace2 A1 A2 (cdr L) ) )  
            (cons (car L) (replace2 A1 A2 (cdr L) ) ) )   
          )
           (T (cons (replace2 A1 A2 (car L))  (replace2 A1 A2 (cdr L) ) )

           )


        )

    )
)


;QUESTION 5

"L1 and L2 are lists of atoms. In these lists, no atom appears more than once. 
common counts how many atoms are contained in both L1 and L2. 

The function will check recursively on L1 by calling member on the first element of L1
If the rerurn value of member is null, that means the 1st element of L1 is not in L2, 
then call common on the rest of L1 and add zero to the result of call. Otherwise, add one.
"
(defun common (L1 L2) 
    (if (null (car L1)) 0 
        (if (null (member (car L1) L2) ) (+ 0 (common (cdr L1) L2) ) (+ 1 (common (cdr L1) L2) )

        )


    )

)

;QUESTION 6

"Splitset construct a new set with elements inside Remain set but not in S.

The function firstly check whether the Remain set was empty.If yes, return null.Otherwise,
check if the first element of Remain was a member in S. If not,include this element in the new set and 
go further checking on the rest of Remain. If the first element lies in S, just skip it and call 
splitset on the rest of Remain.
"
(defun splitset (Remain S) 
    (if (null (car Remain)) nil 
        (if (null (member (car Remain) S)) (cons  (car Remain) (splitset (cdr Remain) S) ) 
        (splitset (cdr Remain) S) 

        )
    )
)


"Optimalsubset finds one subset in S which contains as many of the same elements of  L as possible.

This function firstly check if the input S is null.If so, which means no elements in S were left to be compared,
return the Optimal set found. If not,compare the number of common elements in both (car S) and L with 
the count.If the former is greater, set the former number as NEW count and first element of S as NEW
Opset, and then call optimalsubset on the rest of input set S.Otherwise, 
call optimalsubset on the rest of input set S while all other inputs remain  the same.
"
(defun optimalsubset (S L count Opset) 
    (if (null(car S)) Opset    
        (if (> (common (car S) L) count) (optimalsubset (cdr S) L  (common (car S) L) (car S) )
            (optimalsubset (cdr S) L  count Opset )

        ) 

    )

)

"Recursivesplit solve main part of  the set cover problem by taking the still-to-cover set and S as arguments

This function firstly check if the still-to-cover set was empty.If so,that means nothing left to cover, return null.
Otherwise, it try to find the subset in S which contains as many of the same elements of R as possible and bind this
subset as opset. Then, construct a new set with elements inside opset but not in S, in other words, construct
S - opset,and set it as remainset. Finally,construct a set with opset as first element and result for recursive
call of function recursivesplit on remainset and S, and return it.

"
(defun recursivesplit (R S) 
    (if (null (car R)) R 
        (let* ( (opset (optimalsubset S R 0 () )) (remainset (splitset R opset ))  ) 

        (cons opset  (recursivesplit remainset S)  ) 
        
        )
    )


)




"Setcover should implement the greedy algorithm for the set cover problem. 
The problem would be solved in several rounds. In each round, we select one more subset 
from S until we have a complete cover. We pick a subset that contains as many of the still missing numbers 
as possible. 

This function only do the very first step of finishing the whole problem. It just create a set (for instance, U)
which consist of integers from 1 to N, and then throw this set as input for optimalsubset. 
Optimalsubset will return a subset in S which contains as many of the same elements of U as possible.
This subset, named opset, will be used as argument of splitset which try to the still-to-cover set.
Finally, the solution to the set cover problem will be constructed by putting opset and the result of 
recursivesplit.
"

(defun setcover (N S) 
    (let* ( (opset (optimalsubset S (numbers N) 0 () )) (remainset (splitset (numbers N) opset ))  ) 

        (cons opset (recursivesplit remainset S)
        
        ) 
    )



)

; Cmput 325 Winter 2019 Assignment 2
; CCID 1446915 Student name Weihao Han

;QUESTION 1 remove-identities

"This function compare  two atoms in the expression and evaluate whether the expression could be 
simplified by removing identities.

The function will condition on the arithmetic operation of the current expression. To be more specific,
it will check wheter the expression is in form of (+ 0 Exp), (+ Exp 0), 
(* 1 Exp), (* Exp 1),(- Exp 0). If yes, replace
the current expression Exp. Otherwise, it just return the expression.

"
(defun evaluate-identities (E) 
        (cond 
          ((equal (car E) '+) (cond ((eq (cadr E) 0)  (caddr E))
                                    ((eq (caddr E) 0)  (cadr E))
                                    (T E)
                              )
          )

          ((equal (car E) '*) (cond ((eq (cadr E) 1)  (caddr E))
                                    ((eq (caddr E) 1)  (cadr E))
                                    (T E)
                              )

          )

          ((equal (car E) '-) (if (eq (caddr E) 0)  (cadr E) E)

          )
          (T  E)

        ) 

)



"The input E can be any valid A2Expr.   This function should replace any term of the form (+ 0 Exp), (+ Exp 0), 
(* 1 Exp), (* Exp 1),(- Exp 0)  by Exp. It should apply this simplification recursively to all nested expressions. 
It should not change E in any other way, and return the simplified A2Expr.

The function will condition on  which element in current expression is not atom, and do recursive call on those
elements. Once return was got from the recursion call, evaluate whether the current expression could be 
simplified to a shorter form.

"

(defun remove-identities (E) 
    (if (atom E) E
        (cond ((and (atom (cadr E)) (atom (caddr E)) )  (evaluate-identities E) )
            ((atom (cadr E)) (evaluate-identities (list (car E) (cadr E) (remove-identities (caddr E)) )) )
            ((atom (caddr E)) (evaluate-identities (list (car E) (remove-identities (cadr E))  (caddr E) ))  )
            (T (evaluate-identities (list (car E) (remove-identities (cadr E)) (remove-identities (caddr E)) )) )
        
        )       
        
    )
)


;QUESTION 2 simplify-zeroes
"This function compare  two atoms in the expression and evaluate whether the expression could be 
transfer to zero

The function will condition on the arithmetic operation of the current expression. To be more specific,
it will check wheter the expression is in form of (* 0 Exp), (* Exp 0) or (- Exp Exp). If yes, replace
the current expression with zero. Otherwise, it just return the expression.
"

(defun evaluate-zeroes (E)
    (cond 
        ((equal (car E) '*) (cond ((eq (cadr E) 0)  0)
                                    ((eq (caddr E) 0)  0)
                                    (T E)
                              )

        )

        ((equal (car E) '-) (if (equal (caddr E) (cadr E) ) 0 E)

        )
        (T  E)
    )    
)


"The input E can be any valid A2Expr. This function should replace any term 
of the form (* 0 Exp), (* Exp 0) or (- Exp Exp) by 0. It should apply this simplification recursively 
into all nested expressions. It should not change E in any other way, and return the simplified A2Expr.

The function will check which element in current expression is not atom, and do recursive call on those
elements. Once return was got from the recursion call, evaluate whether the current expression could be 
simplified to zero. 
"
(defun simplify-zeroes (E) 
    (if (atom E) E 
    (cond ((and (atom (cadr E)) (atom (caddr E)) ) (evaluate-zeroes E) )
          ((not (atom (cadr E)) ) (evaluate-zeroes (list (car E) (simplify-zeroes (cadr E))  (caddr E) ))  )

          ((not (atom (caddr E))) (evaluate-zeroes (list (car E) (cadr E) (simplify-zeroes (caddr E)) )) )
          
              
          (T  (evaluate-zeroes  (list (car E) (simplify-zeroes (cadr E)) (simplify-zeroes (caddr E)) ) )  )
        
        ) 
    )
)

;QUESTION 3.1 simplify
"This function should repeatedly call 
1. remove-identities, followed by 
2. simplify-zeroes, 
until no more simplification is possible in either step 1 or 2.

The function will store the input expression, and then call remove-identities, followed by 
simplify-zeroes. Aften then, compare the result with the input. If they were same, stop and 
return the result. If not, do recursive call on the result.
"

(defun simplify (E)
    (let* ((x (remove-identities E))  (y (simplify-zeroes x))  )
        (if (equal E y) y (simplify y)

        )

    )

)

;QUESTION 3 BONUS QUESTION
"There would be no difference if we called these two functions in a different order, because
the simplify will call these two function repeatedly until no more possible simplification.
Specifically, according to Church Rosser Theorem, if input I -> B by  calling remove and then simplify-zeroes,
and I -> C calling  simplify-zeroes and then remove, there must exist D such that B -> D and C -> D by calling 
a sequence of simplify . 
"


;QUESTION 4 normalize
"This function will eliminate the elements of input expression whose coefficients are zero.

The function will firstly check terminal state, and then evaluate the coefficient of the first 
element. If the coefficient is zero, eliminate it and do recursive call on the rest of the input.
Otherwise, construct new list with the first element and the return of recursive call on the rest.
"
(defun eliminate-PExpr (P) 
    (if (null (car P)) NIL 
        (if (eq (caar P) 0) (eliminate-PExpr (cdr P))  (cons (car P) (eliminate-PExpr (cdr P) ) ) )
    
    )

)


"This function will merge the input PExpression by adding the coefficients of x with same exponents.
The input is presumed to be in  non-increasing order.

The function will check whether the input is of length 1. If so, no need to merge and simply return 
the expression. Otherwise, check whether the first two elements in P have same exponents. If yes,
merge these two elements and do recursive call on the rest of P. If not, do recursive call on P except
the first element.
"
(defun merge-PExpr (P) 
    (if (null (cdr P)) P 
        (if (eq (cdar P) (cdadr P))  (merge-PExpr (cons (cons (+ (caar P) (caadr P))  (cdar P))  (cddr P)) ) 
            (cons (car P) (merge-PExpr (cdr P)) )
        )

    )
    
)

"This function is to normalize the input P.
The input P is an arbitrary PExpr. The output is the normal form of P. 

Initially, the function will re-order the input expression to be non-incresaing, depending on the order of 
power. Then, it will call merge-PExpr to merge any elements of same exponent. After then, it try to eliminate
any elements with zero as coefficient. Finally, it examine whether the expression is a empty list and return
the corresponding expression.
"

(defun normalize (P) (let* ( (S (sort P (lambda (x y) (> (cdr x) (cdr y)) ) ) )  
                            (M (merge-PExpr S)) (E (eliminate-PExpr M)) )
                      (if (null (car E) ) NIL E)
    
    )

)

;QUESTION 5 polynomial
"The input E is an arbitrary A2Expr. The output is the equivalent PExpr of E in normal form. 
First implement the three helper functions in 5.1 and 5.2.
"

;QUESTION 5.1 poly-add,poly-subtract
"For these two functions, the inputs P1 and P2 are PExpr in normal form. The output 
should be the sum (for poly-add) or difference (for poly-subtract) of the two PExpr, also in normal form.

The poly-add function firstlt merge the two lists into one, and then normalize the new list.

"

(defun poly-add (P1 P2)
    (let ((U (append P1 P2)) ) (normalize U)

    )

)

"The inverse function make each cofficient of input P inverse 

This function firstly check the terminal state, and then construct a new list
with all element in input but inverse cofficients
"
(defun inverse (P)
    (if (null (car P)) NIL 
        (cons (cons (- (caar P)) (cdar P)) (inverse (cdr P)) )

    )
)

"The poly-subtract first make the secend argument inverse, and then call poly-add
to add them together.
"
(defun poly-subtract (P1 P2)
    (let ((I (inverse P2)) ) (poly-add P1 I)
    )

)

;QUESTION 5.2 poly-multiply 
"The  multiplyElements multiply two dot pairs to form a new dot pair

Specifically, this function multiply the first of X with first of Y as first of new dot pair,
and the last of X with last of Y as last.
"
(defun multiplyElements (X Y)
    (cons (* (car X) (car Y)) (+ (cdr X) (cdr Y)) )

)

"The multiplyList multiply a dot pair with each element in a list, and then form a new list of dot pairs

The function first check if the list is empty.Then construct a new list by multiplying X with first 
element of list P as the first of the new list, and do recursive call on the rest of P.
"
(defun multiplyList (X P)
    (if (null (car P)) NIL 
        (cons (multiplyElements X (car P)) (multiplyList X (cdr P)) )
    )

)

"The listMlist multiply dot pairs in two list and merge all results into a new list
"
(defun listMlist (P1 P2)
    (if (null P1) NIL 
        (append (multiplyList (car P1) P2) (listMlist (cdr P1) P2)
        
        )

    )
)


"The inputs P1 and P2 as well as the output are PExpr in normal form. 
This function compute the multiplicaton of two P Expression
"
(defun poly-multiply (P1 P2)
    (let ((L (listMlist P1 P2))  ) 
         (normalize L)
    )
)


;QUESTION 5.3  polynomial
"Implement polynomial, using the three helper functions.

The function will firstly check whether the current expression is an atom, which is the terminal state.
If yes, determine what type the atom belongs to, integer or X, and then return the corresponding P expression.
If no, that means the current A2 expression is a list. Therefore, it is necessary to check what kind of 
operation it is. After that apply the corrsponding PExpr function on the results of recursive call of 
those two elements of current expression. 
"
(defun  polynomial (E)
    (if (atom E) 
        (cond ((integerp E)  (cons (cons E 0) NIL) ) 
              (T  (cons (cons 1 1) NIL))
        ) 
        (cond ((equal (car E) '+) (poly-add (polynomial (cadr E)) (polynomial (caddr E)) ) )   
              ((equal (car E) '-) (poly-subtract (polynomial (cadr E)) (polynomial (caddr E)) ) ) 
              ((equal (car E) '*) (poly-multiply (polynomial (cadr E)) (polynomial (caddr E)) ) ) 
        )

    )
)



;QUESTION 6 print-pexpr
"The print-pexpr function print a PExpr in normal form
The input P is a PExpr in normal form. Output a string representing P in the following ""common sense"" format:

Print terms in the form cx^n, where c and n are integer
Print ""+"" (space plus space) or " - " (space minus space) between the terms, depending on whether the next term has a positive or negative coefficient
Print terms in sorted order from highest to lowest exponent
Do not print the 1 if the coefficient is 1, except for the constant term
Print -, not -1 if the coefficient is -1, except for the constant term
Do not print *x^0 for a constant term
Print x instead of x^1
Print 0 if the PExpr is nil.
"

"This is a re-define function of concatenate
"
(defun concat (S1 S2) (concatenate 'string S1 S2))

"The write-cofficient determines the representation of plus and minus sign between two terms and 
cofficient of next term. The input I is an integer.

This function will check firstly sign of cofficient.If the cofficient was > 0, it will return a " "+" " when 
cofficient =1 and  " "+ coefficient" " otherwise. If the  cofficient was < 0, it will return a " "-" " when 
cofficient =-1 and  " "- coefficient" " otherwise.
"

(defun write-cofficient(I)
    (cond ((> I 0) (if (= I 1) " + "  (concat " + " (write-to-string I)))
          )
          (T (if (= I -1) " - " (concat " - " (write-to-string (abs I))))
          )
    )
)


"The write-exponent determines the representation of x term. The input E is an integer.

This function will classify on three cases. 1. If E = 1, return x only. 2. If E =0, return ""
3.In other cases, return x^E  
"
(defun write-exponent(E)
    (cond
        ((= E 1) "x")
        ((= E 0)  "")
        (T  (concat "x^" (write-to-string E)))
    )
)

"The deeper-check is a part of  print-pexpr to handle recursive call. 

This function will check if the current expression is null and terminate.
If not, then do the following classfication: 1. If the first element is (1 . 0), which means constant 1,
return  + 1 with result of recusive call on rest of input(which is ""); 2.If the first element is (-1 . 0), 
which means constant -1, return  - 1 with result of recusive call on rest of input(which is ""); 
3. In all other cases, return the combined result of write-cofficient and write-exponent 
with  return of recusive call on rest of input.
"

(defun deeper-check (P)
    (if (null P)
        ""
        (cond ((and (eq 1 (caar P)) (eq 0 (cdar P))) 
                (concat (concat (write-cofficient (caar P)) "1") (deeper-check (cdr P))) )
              ((and (eq (- 1) (caar P)) (eq 0 (cdar P))) 
                (concat (concat (write-cofficient (caar P)) "1") (deeper-check (cdr P))) )
            
            (T (concat (concat (write-cofficient (caar P)) (write-exponent (cdar P))) (deeper-check (cdr P)) ))
        )
    
    )

)

"This function will do classification on the following cases: 1. Input is null, then return 0 in string;
2. Input is a constant, return the constant;
3. First element of input is of cofficient is 1, return x of corrsponding powers in string with recursive call
on the rest of input;
4. First element of input is of cofficient is -1, return x of corrsponding powers  with negative sign
in string, with recursive call on the rest of input;
5. In all other cases, return x of corrsponding powers as well as coffcient in string, 
with recursive call on the rest of input;
"
(defun print-pexpr (P)
    (cond ((null P) "0")
        ((eq 0 (cdar P)) (write-to-string (caar P)) )
        ((eq 1 (caar P)) (concat (write-exponent (cdar P)) (deeper-check (cdr P))) )
        ((eq (- 1) (caar P)) (concat (concat "-" (write-exponent (cdar P))) (deeper-check (cdr P))) )
        (T (concat (concat (write-to-string (caar P)) (write-exponent (cdar P))) (deeper-check (cdr P))) )

    )

)

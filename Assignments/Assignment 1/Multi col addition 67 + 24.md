---
tags:
  - Matthijs
---

This is an implementation for the multi column addition model, asked for in [[Assignment 1]]. 
```lisp
(clear-all)

  

(define-model addition

  

(sgp :esc t :lf .05)

  

(chunk-type add num1 num2 sum split)

(chunk-type goal arg1 arg2 sum hold)

  

(add-dm

  (20add60 isa add num1 twenty num2 sixty sum eighty split yes)

  (7add4 isa add num1 seven num2 four sum eleven split no)

  (80add10 isa add num1 eighty num2 ten sum ninety split yes)

  (90add1 isa add num1 ninety num2 one sum ninety-one split yes)

  (20add7 isa add num1 twenty num2 seven sum twenty-seven split yes)

  (60add4 isa add num1 sixty num2 four sum sixty-four split yes)

  (10add1 isa add num1 ten num2 one sum eleven split yes)

  (1add0 isa add num1 one num2 zero sum one split no)

  (initial-goal isa goal arg1 twenty-seven arg2 sixty-four)

)

  

(P initialize-mc-add

    =goal>

      isa       goal

      arg1      =num1

      arg2      =num2

      sum       nil

      hold      nil

  ==>

    =goal>

      isa       goal

      arg1      =num1

      arg2      =num2

      sum       =num1

      hold      =num2

    +retrieval>

      isa       add

      sum       =num1

      split     yes

)

  

(P split-first

    =goal>

      isa       goal

      arg1      =num1

      arg2      =num2

      sum       =num1

      hold      =num2

    =retrieval>

      isa       add

      sum       =num1

      num1      =tens

      num2      =ones

  ==>

    =goal>

      isa       goal

      arg1      =tens

      sum       =ones

    +retrieval>

      sum       =num2

      split     yes

)

  

(P split-second

    =goal>

      isa       goal

      arg1      =num1

      arg2      =num2

    - sum       =num1

      hold      =num2

    =retrieval>

      isa       add

      sum       =num2

      num1      =tens

      num2      =ones

==>

    =goal>

      isa       goal

      arg2      =tens

      hold      =ones

    +retrieval>

      isa       add

      num1      =num1

      num2      =tens

)

  

(P add-first

    =goal>

      isa       goal

      arg1      =num1

      arg2      =num2

      sum       =num3

      hold      =num4

    =retrieval>

      isa       add

      num1      =num1

      num2      =num2

      sum       =sum

  ==>

    =goal>

      isa       goal

      arg1       =sum

      arg2      nil

    +retrieval>

      isa       add

      num1      =num3

      num2      =num4

)

  

(P add-second

    =goal>

      isa       goal

      arg1      =num1

      arg2      nil

      sum       =num2

      hold      =num3

    =retrieval>

      isa       add

      num1      =num2

      num2      =num3

      sum       =sum

  ==>

    =goal>

      isa       goal

      sum       nil

      hold      =sum

    +retrieval>

      isa       add

      num1      =num1

      num2      =sum

)

  

(P find-double ; we split the sum of ones again if it is two digits

    =goal>

      isa       goal

      arg1      =num1

      arg2      nil

      sum       nil

      hold      =num2

    ?retrieval>

      state     error

  ==>

    =goal>

      isa       goal

      arg1      =num1

      arg2      nil

      sum       nil

      hold      =num2

    +retrieval>

      isa       add

      sum       =num2

      split     yes

)

  

(P split-double ; in case sum of ones is two digits

    =goal>

      isa       goal

      arg1      =num1

      arg2      nil

      sum       nil

      hold      =num2

    =retrieval>

      isa       add

      sum       =num2

      num1      =tens

      num2      =ones

  ==>

    =goal>

      isa       goal

      arg1      =num1

      arg2      =tens

      sum       =ones

      hold      zero

    +retrieval>

      isa       add

      num1      =num1

      num2      =tens

)

  
  

(P final-sum

    =goal>

      isa       goal

      arg1      =num1

      arg2      nil

      sum       nil

      hold      =num2

    =retrieval>

      isa       add

      num1      =num1

      num2      =num2

      sum       =answer

  ==>

  =goal>

    isa         goal

    arg1        nil

    arg2        nil

    sum         =answer

    hold        nil

  !output!      =answer

)

  

(goal-focus initial-goal)

)
```
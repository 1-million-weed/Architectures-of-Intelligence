(clear-all)

(define-model addition

(sgp :esc t :lf .05)

; for the implementation of this model i wanted the least amount of variables used 
; {i did my best. would have liked to not have to use 'hold'}
(chunk-type add num1 num2 sum split) ; we use the add chunk type to split numbers as well
(chunk-type goal arg1 arg2 sum hold) 

(add-dm
   ; this first section was for summing 27 and 64
  (20add60 isa add num1 twenty num2 sixty sum eighty split yes) ;NOTETOSELF: the splits for tens summed should probably be set to no iso yes
  (7add4 isa add num1 seven num2 four sum eleven split no)
  (80add10 isa add num1 eighty num2 ten sum ninety split yes)
  (90add1 isa add num1 ninety num2 one sum ninety-one split yes)
  (20add7 isa add num1 twenty num2 seven sum twenty-seven split yes)
  (60add4 isa add num1 sixty num2 four sum sixty-four split yes)
  (10add1 isa add num1 ten num2 one sum eleven split yes)
  (1add0 isa add num1 one num2 zero sum one split no) ; the add 0 is a mistake in implementation {which i dont feel like fixing}

  ; this second section is to see if the code is usable for all addition {given the dm is provided}
  (20add3 isa add num1 twenty num2 three sum twenty-three split yes)
  (3add0 isa add num1 three num2 zero split no)
  (3add2 isa add num1 three num2 two sum five split no)
  (20add10 isa add num1 twenty num2 ten sum thirty split yes)
  (10add2 isa add num1 ten num2 two sum twelve split yes)
  (30add5 isa add num1 thirty num2 five sum thirty-five split yes)

  (initial-goal isa goal arg1 twenty-three arg2 twelve) ; arg1 and arg2 are the numbers to be summed, arg1 > arg2 > 10, 
)

(P initialize-mc-add
    =goal>
      isa       goal
      arg1      =num1
      arg2      =num2
      sum       nil
      hold      nil
  ==>
    =goal>
      isa       goal
      arg1      =num1
      arg2      =num2
      sum       =num1
      hold      =num2
    +retrieval>
      isa       add
      sum       =num1
      split     yes
)

(P split-first
    =goal>
      isa       goal
      arg1      =num1
      arg2      =num2
      sum       =num1
      hold      =num2
    =retrieval>
      isa       add
      sum       =num1
      num1      =tens
      num2      =ones
  ==>
    =goal>
      isa       goal
      arg1      =tens
      sum       =ones
    +retrieval>
      sum       =num2
      split     yes
)

(P split-second
    =goal>
      isa       goal
      arg1      =num1
      arg2      =num2
    - sum       =num1
      hold      =num2
    =retrieval>
      isa       add
      sum       =num2
      num1      =tens
      num2      =ones
==>
    =goal>
      isa       goal
      arg2      =tens
      hold      =ones
    +retrieval>
      isa       add
      num1      =num1
      num2      =tens
)

(P add-first
    =goal>
      isa       goal
      arg1      =num1
      arg2      =num2
      sum       =num3
      hold      =num4
    =retrieval>
      isa       add
      num1      =num1
      num2      =num2
      sum       =sum
  ==>
    =goal>
      isa       goal
      arg1       =sum
      arg2      nil
    +retrieval>
      isa       add
      num1      =num3
      num2      =num4
)

(P add-second
    =goal>
      isa       goal
      arg1      =num1
      arg2      nil
      sum       =num2
      hold      =num3
    =retrieval>
      isa       add
      num1      =num2
      num2      =num3
      sum       =sum
  ==>
    =goal>
      isa       goal
      sum       nil
      hold      =sum
    +retrieval>
      isa       add
      num1      =num1
      num2      =sum
)

(P find-double ; we split the sum of ones again if it is two digits
    =goal>
      isa       goal
      arg1      =num1
      arg2      nil
      sum       nil
      hold      =num2
    ?retrieval>
      state     error
  ==>
    =goal>
      isa       goal
      arg1      =num1
      arg2      nil
      sum       nil
      hold      =num2
    +retrieval>
      isa       add
      sum       =num2
      split     yes
)

(P split-double ; in case sum of ones is two digits 
    =goal>
      isa       goal
      arg1      =num1
      arg2      nil
      sum       nil
      hold      =num2
    =retrieval>
      isa       add
      sum       =num2
      num1      =tens
      num2      =ones
  ==>
    =goal>
      isa       goal
      arg1      =num1
      arg2      =tens
      sum       =ones
      hold      zero
    +retrieval>
      isa       add
      num1      =num1
      num2      =tens
)


(P final-sum
    =goal>
      isa       goal
      arg1      =num1
      arg2      nil
      sum       nil
      hold      =num2
    =retrieval>
      isa       add
      num1      =num1
      num2      =num2
      sum       =answer
  ==>
  =goal>
    isa         goal
    arg1        nil
    arg2        nil 
    sum         =answer
    hold        nil
  !output!      =answer
)

(goal-focus initial-goal)
)

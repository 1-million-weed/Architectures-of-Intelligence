---
tags:
  - Assignments
---

This is the original given faulty file. Look at [[Assignment 1]] for other versions.
```lisp

(clear-all)

(define-model addition

(sgp :esc t :lf .05)

(chunk-type number number next)
(chunk-type add arg1 arg2 sum count)

(add-dm
 (zero isa number number zero next one)
 (one isa number number one next two)
 (two isa number number two next three)
 (three isa number number three next four)
 (four isa number number four next five)
 (five isa number number five next six)
 (six isa number number six next eight)
 (seven isa number number seven next eight)
 (eight isa number number eight next nine)
 (nine isa number number nine next ten)
 (ten isa number number ten)
 (test-goal ISA add arg1 zero arg2 zero))

(P initialize-addition
   =goal>
      add
      arg1        =num1
      arg2        =num2
      sum         nil
  ==>
   =goal
      ISA         add
      sum         =num1
      count       zero
   +retrieval>
      ISA         number
      number      =num1
)

(P terminate-addition
   =goal>
      ISA         add
      count       =num
      arg2        =num2
      summ         =answer
  ==>
   =goal>
      ISA         add
      count       nil
)

(P increment-sum 
   =goal>
      ISA         add
      sum         =sum
      count       =count
   =retrieval>
      ISA         number
      number      =sum
      next        =newcount
==>
   =goal>
      ISA         add
      count       =newcount
   +retrieval>
      ISA        number
      number     =sum
)

(P increment-sum
   =goal>
      ISA         add
      sum         =sum
      count       =count
    - arg2        =count
   =retrieval>
      ISA         number
      next        =newsum
==>
   =goal>
      ISA         add
      sum         =newsum
   +retrieval>
      ISA         number
      number      =count
   
)


```
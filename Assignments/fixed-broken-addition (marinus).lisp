
(clear-all)

(define-model addition

(sgp :esc t :lf .05)

(chunk-type number number next)
(chunk-type add arg1 arg2 sum count)

(add-dm
 (zero isa number number zero next one) ; 'ísa' can also be 'ISA'
 (one isa number number one next two)
 (two isa number number two next three)
 (three isa number number three next four)
 (four isa number number four next five)
 (five isa number number five next six)
 (six isa number number six next seven) ; replaced 'eight' with 'seven'
 (seven isa number number seven next eight)
 (eight isa number number eight next nine)
 (nine isa number number nine next ten)
 (ten isa number number ten)
 (test-goal ISA add arg1 two arg2 three))

(P initialize-addition
   =goal>
      ISA         add ; added 'ISA'
      arg1        =num1
      arg2        =num2
      sum         nil
  ==>
   =goal> ; missing '>'
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
      arg2        =num ; changed 'num2' to 'num'. when count has reached arg2 we reached the answer 
      sum         =answer ; changed 'summ' to 'sum'
   =retrieval>
      ISA         number
      number      =answer ; need to get the answer from somewhere...
  ==>
   =goal>
      ISA         add
      count       nil
   !output!       =answer  ; added output
)

(P increment-count ; already have an increment-sum...
   =goal>
      ISA         add
      sum         =sum
      count       =count
   =retrieval>
      ISA         number
      number      =count ; changed 'sum' to 'count'. keeping track of count, not sum 
      next        =newcount 
  ==> ; spacing convention
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
      number      =sum ; added line to find the right dm chunk
      next        =newsum
  ==> ; spacing convention
   =goal>
      ISA         add
      sum         =newsum
   +retrieval>
      ISA         number
      number      =count
   
)

; Missing starting goal
(goal-focus test-goal)
) ; closing bracket for 'define-model addition' (this was annoying)

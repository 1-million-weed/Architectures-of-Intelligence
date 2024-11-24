(clear-all)

(define-model subitize

(sgp :v t)

(sgp :show-focus t 
     :visual-num-finsts 10 
     :visual-finst-span 10)

(chunk-type count count step)
(chunk-type number number next vocal-rep)

(add-dm 
(zero isa number number zero next one vocal-rep "zero")
(one isa number number one next two vocal-rep "one")
(two isa number number two next three vocal-rep "two")
(three isa number number three next four vocal-rep "three")
(four isa number number four next five vocal-rep "four")
(five isa number number five next six vocal-rep "five")
(six isa number number six next seven vocal-rep "six")
(seven isa number number seven next eight vocal-rep "seven")
(eight isa number number eight next nine vocal-rep "eight")
(nine isa number number nine next ten vocal-rep "nine")
(ten isa number number ten next eleven vocal-rep "ten")
(eleven isa number number eleven)
(goal isa count step start)
(start)
(attend)
(count)
(report)
(next)
)

(p find-first
 ; This production finds the first 'x'
	=goal>
		ISA		   count 
      count       nil
		step		   start
   ?visual-location>
      state       free     ; ensure the module is free
==>
   =goal>
      step        attend   ; attend to the first item
      count       zero     ; start counting
   +visual-location>
      :attended   nil      ; find the first item to attend to
      screen-x    lowest   ; find leftmost x
)

(P attend
   ; Shifts attenion to the first 'x'
   =goal>
      ISA         count 
      step        attend      ; found an 'x' to attend to.
      count       =number     ; start retrieval for count
   =visual-location>          ; visual-location filled
   ?visual>
      state       free        ; prevent jamming
==>
   ; 
   +visual>
      cmd         move-attention    ; move atention to
      screen-pos  =visual-location  ; the point
   =goal>
      step        count       ; start counting
)

(p start-count
   =goal>
      ISA         count
      step        count
      count       =number
   ?retrieval>
      state       free
==>
   -visual-location>
   +retrieval>
      number      =number
   =goal>
      step        next
)

(p count-and-find-next
   =goal>
      ISA         count
      step        next
   =retrieval> 
      next        =next
   ?visual-location>
      state       free
==>
   =goal>
      step        attend
      count       =next
   +visual-location>
      :attended   nil
      screen-x    lowest ; find leftmost x
)

(p start-report
   =goal>
      ISA         count
      step        attend
      count       =final
   ?visual-location>
      buffer      failure
==>
   +retrieval>
      number      =final
   =goal>
      step        report
)

(p report
   =goal>
      ISA         count
      step        report
      count       =final
   =retrieval>
      vocal-rep   =text
   ?vocal>
      state       free
==>
   +vocal>
      cmd         speak
      string      =text
   -goal>   
)

(goal-focus goal)

(spp start-report :u -2)

)
#|
so i hope this is a comment.
idea for later is to use only 4 finsts 
and we keep track of the count. 
we implement a search pattern that works in areas. 
so we search in an area till the fints are full then we 
mentally move on from that area
|#
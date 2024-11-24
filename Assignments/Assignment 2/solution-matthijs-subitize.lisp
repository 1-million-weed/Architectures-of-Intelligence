"""
Authors: Marinus van den Ende (s5460484), Matthijs Prinsen (s4003365)
Description: Subitizing model that counts up to ten X's on a screen and speaks the resulting amount

Steps:
  1. [start] find the first x on the screen
  2. [find] locate next unattended 'x' 
            (left to right, due to reading direction)
  3. [attend] attend the x by adding its location to the visual buffer
  4. [start-count] initialize count
  5. [add] increase the count by one
  6. [respond] find vocal representation of the count
  7. [end] respond by vocalizing the count &
           clear the goal buffer to ready for subsequent tasks
"""

(clear-all)

(define-model subitize

;(sgp :v t)

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
(start) ; the 'isa chunk' seems unnecessary and is thus removed
(attend)
(find)
(respond)
(start-count)
(add)
(end)
)

(p find-first
; This production finds the first x on the screen
  =goal>
    isa         count
    step        start
    count       nil
  ?visual-location>
    state       free        ; avoid jamming by making sure module is free
==>
  =goal>
     step       attend
     count      zero        ; sets goal to starts counting from "zero"
  +visual-location>
    :attended   nil         ; finds first unattended
    screen-X    lowest      ; finds leftmost point
)

(p attend
; This productions shifts the attention to the next X
  =goal>
    isa         count
    step        attend
  =visual-location>             ; need to make sure the module is full
  ?visual>                      
    state       free            ; avoid jamming
==>
  =goal>
    step        start-count     ; new goal to start counting
  +visual>
    ; we move the attention towards location in the visual-lovation buffer
    cmd         move-attention  
    screen-pos  =visual-location
)

(p start-count
; This step starts the count when an x is attended
  =goal>
    step        start-count
    count       =number
==>
  =goal>
    step        add             ; new goal to add the point to the count
  +retrieval>
    number      =number         ; retrieval request for next number
)

(p end-count
; This step adds one to the count
  =goal>
    step        add
  =retrieval>
    next        =next           ; get the next number
==>
  =goal>
    step        find            ; new goal to find next point
    count       =next
  -retrieval>                   ; clear the retrieval buffer
)

(p find-next
; This production finds the next x on the screen
  =goal>
    isa         count
    step        find
    count       =number
  ?visual-location>
    state       free            ; avoid jamming
==>
  =goal>    
     step       attend          ; new goal state for attending the next point
  +visual-location>
    :attended   nil             ; find an unattended point
    screen-X    lowest          ; search left to right
)

(p no-next
; This production fires when all the x's were found
  =goal>
    step        attend
  ?visual-location>
    buffer      failure         ; buffer fails when no points are unattended
==>
  =goal>
    step        respond         ; now we respond the count
)

(p start-respond
; This production starts the reporting process
  =goal>
    step        respond
    count       =number
==>
  +retrieval> 
    number      =number         ; retrieval of vocal-rep
  =goal>
    step        end             ; goal state for voicing number
)

(p end-respond
; This production produces the vocal response
  =goal>
    step        end
  =retrieval> 
    vocal-rep   =text           ; retrieve string text
  ?vocal>
    state       free            ; avoid jamming
==>
  +vocal>
    cmd         speak           ; ask vocal to speak
    string      =text           ; string to speak
  -goal>                        ; done!
)

(goal-focus goal)
)
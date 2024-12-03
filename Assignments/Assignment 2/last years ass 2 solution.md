---
tags:
  - Matthijs
  - Assignments
  - Solutions
---
```lisp
"""

Authors: Febe van Sommeren (s5069564), Matthijs Prinsen (s4003365)

Description: Subitizing model that counts up to ten X's on a screen and speaks the resulting amount

Date:26/11/2023

"""

  

(clear-all)

  

(define-model subitize

  

(sgp :v t)

  

(sgp :show-focus t

     :visual-num-finsts 10

     :visual-finst-span 10)

  

(chunk-type count count step)

(chunk-type number number next vocal-rep)

  

(add-dm

        (attend isa chunk)

        (find isa chunk)

        (respond isa chunk)

        (start-count isa chunk)

        (add isa chunk)

        (end isa chunk)

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

)

  

(p find-first

; This production finds the first x on the screen

  =goal>

    isa         count

    step        start

    count       nil

  ?visual-location>

    state       free

==>

  =goal>

     step       attend

     count      zero

  +visual-location>

    :attended   nil

    screen-X    lowest

)

  

(p attend

; This productions shifts the attention to the next X

  =goal>

    isa         count

    step        attend

  =visual-location>

  ?visual>

    state       free

==>

  =goal>

    step        start-count

  +visual>

    cmd         move-attention

    screen-pos  =visual-location

)

  

(p start-count

; This step starts the count when an x is attended

  =goal>

    step        start-count

    count       =number

==>

  =goal>

    step        add

 +retrieval>

    number      =number

)

  

(p end-count

; This step adds one to the count

  =goal>

    step        add

  =retrieval>

    next        =next

==>

  =goal>

    step        find

    count       =next

  -retrieval>

)

  

(p find-next

; This production finds the next x on the screen

  =goal>

    isa         count

    step        find

    count       =number

==>

  =goal>

     step       attend

  +visual-location>

    :attended   nil

)

  

(p no-next

; This production fires when all the X's were found

  =goal>

    step        attend

  ?visual-location>

    buffer      failure

==>

  =goal>

    step        respond

)

  

(p start-respond

; This production starts the reporting process

  =goal>

    step        respond

    count       =number

==>

  +retrieval>

    number      =number

  =goal>

    step        end

)

  

(p end-respond

; This production produces the vocal response

  =goal>

    step        end

  =retrieval>

    vocal-rep   =text

  ?vocal>

    state       free

==>

  +vocal>

    cmd         speak

    string      =text

  -goal>

)

  

(goal-focus goal)

)
```
;; Matthijs Prinsen & Marinus v/d Ende

(clear-all)

(define-model 1-hit-model

  ;; do not change these parameters
  (sgp :esc t :bll .5 :ol t :sim-hook "1hit-bj-number-sims"
    :cache-sim-hook-results t :er t :lf 0)

  ;; adjust these as needed
  (sgp :v nil :ans .2 :mp 10.0 :rt -60)
  ;; :v   - verbose
  ;; :ans - Activation Noise Instantanuous
  ;; :mp  - Partial Matching
  ;; :rt  - Retrieval Threshold

  ;; This type holds all the game info 
  (chunk-type game-state
    mc1 mc2 mc3 mstart mtot mresult oc1 oc2 oc3 ostart otot oresult state)

  ;; This chunk-type should be modified to contain the information needed
  ;; for your model's learning strategy
  ;; DESIGN CHOICE: we want to only work with the total and decide on that
  ;; if we should hit or stay.
  (chunk-type learned-info mstart action)

  ;; Declare the slots used for the goal buffer since it is not set in the
  ;; model defintion or by the productions.
  (declare-buffer-usage goal game-state :all)

  ;; Create chunks for the items used in the slots for the game
  ;; information and state
  (define-chunks win lose bust retrieving start results)

  ;; Provide a keyboard for the model's motor module to use
  (install-device '("motor" "keyboard"))

  ;; at the start of the game, 
  ;; we try to see if we have an action for the first card dealt 
  (p start
    =goal>
      isa     game-state
      state   start
      mstart  =mystart
    ==>
    =goal>
      state   retrieving
    +retrieval>
      isa     learned-info
      mstart  =mystart
    - action  nil     ;; action slot must be filled.
  )

  ;; if there is no previous action we hit
  ;; DESIGN CHOICE: we want to hit a lot early, 
  ;; which loses a few games at the start, but provides more
  ;; info for later games.
  (p cant-remember-game
    =goal>
      isa       game-state
      state     retrieving
      mstart    =mystart
    ?retrieval>
      buffer    failure   ;; If we failed to find a fact
    ?manual>
      state     free
    ==>
    =goal>
      state     nil       ;; finished for this round
    +manual>
      cmd       press-key
      key       "h"
    ) 

  ;; if we do have a fact retrieved about the current hand total,
  ;; we execute that strategy
  (p remember-game
    =goal>
      isa       game-state
      state     retrieving
    =retrieval>
      isa       learned-info    ;; we matched a previous fact
      action    =act
    ?manual>
      state     free
    ==>
    =goal>
      state     nil
    +manual>
      cmd       press-key
      key       =act            ;; perform the previous fact's action
    +imaginal>
      action    =act
    @retrieval> ;; WHAT IS THE @?
    ) 
    ;; The '@' is called the overwrite function (like in java @overwite)
    ;; It has the production modify a chunk in a buffer. 
    ;; similar to the '=' operator
    ;; With overwite only slots and values specified in the overwrite action
    ;; will remain in the chunk
    ;;   ALL other slot and values are ERASED.
    ;; In this case:
    ;;   The chunk in the buffer is NOT sent to declarive memory and instead
    ;;   is FORGOTTEN as if never there.
    ;; NOTE: Used here to prevent strengthening the chunk more in the DM
    ;; WHY? WE DONT NEED TO RESTRENGTHEN THAT CHUNK AFTER RECALLING IT.

;;------------------------------------------------------------------------
;; UP TILL HERE WE HAVE 10 SECONDS TO THINK AND ACT
;;------------------------------------------------------------------------

  ;; On a win where we hit, 
  ;; we save our action 'h' with the total
  (p results-hit-win
    =goal>
      isa       game-state
      state     results
      mresult   win
      mstart    =mystart  
    - mc3       nil         ;; third card slot is full ~ hit
    ?imaginal>
      state     free
    ==>
    !output!    (I win)
    =goal>
      state     nil
    +imaginal>
      isa       learned-info
      mstart    =mystart    ;; remember that we want to hit at this total.
      action    "h"
    )
  
  ;; if we stay and win, 
  ;; we need to encode that number as well.
  (p resutls-stay-win
    =goal>
      isa       game-state
      state     results
      mresult   win
      mstart    =mystart
      mtot      =mystart ;; start equals total ~ stay
    ?imaginal>
      state     free
    ==>
    !output!    (I win)
    =goal>
      state     nil
      mstart    =mystart ;; want to remmber to stay at this total.
      action    "s"
  )

  ;; if we hit and bust, (we can only hit and bust)
  ;; we want to learn to stay at our start total
  (p results-stay-bust
    =goal>
      isa       game-state
      state     results
      mresult   bust
      mstart    =mystart
    ?imaginal>
      state     free
    ==>
    !output!    (I bust)
    =goal>
      state     nil
    +imaginal>
      isa       learned-info
      mstart    =mystart  ;; want to remember to stay at this total.
      action    "s"
    )

  ;; If the oponent stays and wins,
  ;; we can do some quick maths to learn that.
  (p results-opponent-stay-won
    =goal>
      isa       game-state
      state     results
      oresult   win
      otot      =ototal   ;; sarting total = end total (stayed)
      oc3       nil       ;; if this is empty they stayed
    ?imaginal>
      state     free
    ==>
    =goal>  ;; we want to keep the goal buffer so result-lost can fire
    +imaginal>
      isa       learned-info
      mstart    =ototal
      action    "s"       ;; we want to stay in this case
  )
  ;; little side note i realised while reading the comments one 
  ;; last time before handing in. Here above we dont clear the goal 
  ;; buffer. therefore, theoretically, it should go into a loop. 
  ;; i dont see that happening in the results... so i left it.

  ;; if we lost, and our cards were lower than our oponents, 
  ;; we might want to hit. this could be a lower utility production
  (p results-lost
    =goal>
      isa       game-state
      state     results
      mresult   lose
      mtot      =mytot
    > otot      =mytot ;; otot is bigger than mytot
    ?imaginal>
      state     free
    ==>
    !output!    (I lose)
    =goal>
      state     nil
    +imaginal>  
      isa       learned-info
      mstart    =mytot
      action    "h" ;; if we lost because we were too low, we hit.
  )

  ;; clearing the imaginal chunk to send the chunk into the dm
  (p clear-new-imaginal-chunk
    ?imaginal>
      state   free
      buffer  full
    ==>
      -imaginal>
    )
)
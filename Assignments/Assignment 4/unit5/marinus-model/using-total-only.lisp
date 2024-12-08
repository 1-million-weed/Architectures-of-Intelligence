;; Matthijs Prinsen & Marinus v/d Ende
;; Todo:

;; 1. use spreading activation to allow for near misses
;;    I will need to play around with this parameter later
;; 2. maybe create a subcvolise module to rehearse the 
;;    known chunks. This would use the 10 seconds more 
;;    efficiently

;; WE SHOULD INCLUDE BOTH CARDS AND RESULTS FOR BETTER  
;;  PARTIAL MATCHING

;; ADD COMPOUND PRODUCTION THING 
;; NEED TO KNOW WHETHER THIS IS A FUNCTION YOU CAN TURN ON OR
;;   IF YOU NEED TO DO THIS YOURSELF.
;; I THINK WE NEED TO DO THIS OURSELVES

(clear-all)

(define-model 1-hit-model

  ;; do not change these parameters
  (sgp :esc t :bll .5 :ol t :sim-hook "1hit-bj-number-sims"
    :cache-sim-hook-results t :er t :lf 0)

  ;; adjust these as needed
  (sgp :v nil :ans .2 :mp 10.0 :rt -60)
  ;; :v   - verbose
  ;; :ans - Activation Noise Instantanuous
  ;; :mp  - Partial Mapping
  ;; :rt  - Retrieval Threshold

  ;; This type holds all the game info 
  (chunk-type game-state
    mc1 mc2 mc3 mstart mtot mresult oc1 oc2 oc3 ostart otot oresult state)

  ;; This chunk-type should be modified to contain the information needed
  ;; for your model's learning strategy
  ;; DESIGN CHOICE: we want to only work with the total and decide on that
  ;; if we should hit or stay.
  (chunk-type learned-info tot action)

  ;; Declare the slots used for the goal buffer since it is not set in the
  ;; model defintion or by the productions.
  ;; See the experiment code text for more details.
  (declare-buffer-usage goal game-state :all)

  ;; Create chunks for the items used in the slots for the game
  ;; information and state
  (define-chunks win lose bust retrieving start results)

  ;; Provide a keyboard for the model's motor module to use
  (install-device '("motor" "keyboard"))

  ;; at the start of the game, 
  ;; we try to see if we have a strategy for the first card dealt 
  (p start
    =goal>
      isa     game-state
      state   start
      mtot    =my 
    ==>
    =goal>
      state   retrieving
    +retrieval>
      isa     learned-info
      tot     =my
    - action  nil ;; we want to find a previous action, 
                  ;;  the action slot should not be empty
    )

  ;; if there is no previous action we hit
  ;; DESIGN CHOICE: here we want to hit a lot early, 
  ;; which probably loses a few games at the start, but provides more
  ;; info for later games
  (p cant-remember-game
    =goal>
      isa     game-state
      state   retrieving
      mtot    =my
    ?retrieval>
      buffer  failure
    ?manual>
      state   free
    ==>
    =goal>
      state   nil
    +manual>
      cmd     press-key
      key     "h"
    +imaginal>
      tot     =my
      action  "h"
    ) 

  ;; if we do have a fact retrieved about the current card,
  ;; we execute that strategy
  (p remember-game
    =goal>
      isa     game-state
      state   retrieving
      mtot    =my
    =retrieval>
      isa     learned-info
      action  =act
    ?manual>
      state   free
    ==>
    =goal>
      state   nil ;; for now we wait for the 10 seconds to end.
    +manual>
      cmd     press-key
      key     =act
    +imaginal>
      tot     =my
      action  =act
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
    ;; DONT KNOW FOR SURE IF ITS THE RIGHT MOVE HERE.

;; WE CAN ADD MORE MODULES TO ADD THE OPONENTS CARDS INTO A BUFFER TO LATER
;; SAVE THEIR HAND RESULTS AS WELL.

;;-------------------------------------------------------------
;; MATTHIJS I AM NOT DONE YET. I WILL LET YOU KNOW ONCE I AM
;;-------------------------------------------------------------
  ;; On a win, we save our action 'h' with the dealt cards and total
  (p results-should-hit
    =goal>
      isa     game-state
      state   results
      mresult win
      mtot    =my
    ?imaginal>
      state   free
    ==>
    !output!  (I =outcome)
    =goal>
      state   nil
      mresult =outcome
    +imaginal>
      isa     learned-info
      tot     =my
      action  "h"
    )

  ;; on a loss or bust we remember that we should stay on that total.
  (p results-should-stay
    =goal>
      isa     game-state
      state   results
      mresult =outcome ;; this can be either 'lost' or 'bust'
      tot     =mytot
    ?imaginal>
      state   free
    ==>
    !output!  (I =outcome) ;; I 'lost'/'bust'
    =goal>
      state   nil
      mresult =outcome
    +imaginal>
      isa     learned-info
      tot     =mytot
      action  "s"
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

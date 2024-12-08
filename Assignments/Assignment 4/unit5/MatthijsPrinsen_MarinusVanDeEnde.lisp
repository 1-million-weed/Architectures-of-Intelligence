;; Matthijs Prinsen & Marinus v/d Ende
;; Todo: 

;; RESULTS STATE CURRENTLY RUNS ONE PRODUCTION, WE WANT TO RUN ALL THREE
;; WE CAN MAKE THE RESULT STATE NOT UPDATE FROM THE PRODUCTIONS, BUT HAVE A NEW P UPDATE THE STATE WHEN THERE ARE NO MORE TASKS

;; LOOK AT MRESULTS AND ORESULTS WHEN EVALUATING HIT OR STAY

;; 3. use spreading activation to allow for near misses

;; 5. add 'fuck it' production to hit when unsure 
;; 6. add 'pussy out' production to hit when unsure 

;; WE SHOULD INCLUDE BOTH CARDS AND RESULTS FOR BETTER PARTIAL MATCHING

;; WHAT ABOUT A PRODUCTION THAT REPEATS THE CONCEPTS LEARNED UP TILL NOW
;; A PERSON LERANING BLACKJACK WOULD CONTINUESLY REVIEW WHAT THEYVE LEARNED

;; ? #|Warning: Parameter :SIM-HOOK cannot take value "1hit-bj-number-sims" because it must be a function, string naming a command, or nil. |#

(clear-all)

(define-model 1-hit-model 
    
  ;; do not change these parameters
  (sgp :esc t :bll .5 :ol t :sim-hook "1hit-bj-number-sims" 
       :cache-sim-hook-results t :er t :lf 0)
  
  ;; adjust these as needed
  (sgp :v nil :ans .2 :mp 10.0 :rt -60)
  
  ;; This type holds all the game info 
  (chunk-type game-state
     mc1 mc2 mc3 mstart mtot mresult oc1 oc2 oc3 ostart otot oresult state)
  
  ;; This chunk-type should be modified to contain the information needed
  ;; for your model's learning strategy
  ;; DESIGN CHOICE: we want to save the oppopents action as our own, 
  ;; no need for distinction where the learned info came from
  (chunk-type learned-info c1 c2 tot action)
  
  ;; Declare the slots used for the goal buffer since it is
  ;; not set in the model defintion or by the productions.
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
       isa game-state ;; OPTIONAL; WE INCLUDE THE OPPONENTS FIRST CARD FOR FURTHER SPREADING ACTIVATION
       state start
       MC1 =c1 ;;WE WANT TO FIND AN EXACT MATCH, BUT SHOULD ALLOW FOR SPREADING ACTIVATION
       MC2 =c2 ;;ARE WE ALREADY USING THAT, OR DO WE STILL HAVE TO IMPLEMENT IT?
       mtot =my ;; OPTIONAL: WE ALSO ADD THE OPPONENTS CARDS (FOR E.G. IF THEY HAVE A BAD HAND, WE MIGHT BE INCLINED TO STAY)
    ==>
     =goal>
       state retrieving
     +retrieval>
       isa learned-info
       C1 =c1
       C2 =c2
       tot =my
     - action nil ;; we want to find a previous action, the action slot should not be empty
     )

  ;; if there is no previous action we hit
  ;; DESIGN CHOICE: here we want to hit a lot early, 
  ;; which probably loses a few games at the start, but provides more info for later games
  (p cant-remember-game
     =goal>
       isa game-state
       state retrieving
       MC1  =c1 
       MC2  =c2
       MTOT =my
     ?retrieval>
       buffer  failure
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key "h"
     +imaginal>
       action "h"
       c1 =c1
       c2 =c2
       tot =my
       ) 
  
  ;; if we do have a fact retrieved about the current card,
  ;; we execute that strategy
  (p remember-game
     =goal>
       isa game-state
       state retrieving
       mc1 =c1
       mc2 =c2
       MTOT =MY
     =retrieval>
       isa learned-info
       action =act
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key =act
     +imaginal>
      action =act
      C1 =c1
      C2 =c2
      TOT =MY
     @retrieval>)
  
  ;; On a win, we save our action 'h' with the dealt cards and total
  (p my-results-should-hit
     =goal>
       isa game-state
       state results
       mresult win
       MC1 =c1
       MC2 =c2
       mtot =my ;; DO WE ALSO CHECK OPPONENTS CARDS HERE? IF WE WANT TO LOOK AT THEIR TOTAL, WE'D HAVE TO SAVE OUR GAMES DIFFERNTLY
     ?imaginal>
       state free
    ==>
     !output! (I WIN)
     =goal>
       state results
     +imaginal>
       C1 =c1
       C2 =c2
       tot =my
       action "h")
       
  ;; hitting is a highly preferred action with a utility of 10
  (spp results-should-hit :u 10)

  ;; we encode the opponents results too,
  ;; we can base our next action of this  
  (p opp-results-should-hit
     =goal>
       isa game-state
       state results
       oresult win
       oC1 =c1
       oc2 =c2
      -oc3 nil ;; the opponent hit
       otot =tot
     ?imaginal>
       state free
    ==>
     =goal> ;; IS THIS =GOAL> OPTIONAL?
       state results
     +imaginal> ;; we save the opponents actions if they win
       c1 =C1
       c2 =c2 
       tot =tot
       action "h")

  ;; when winning, we encode our action with the cards into the dm via imaginal buffer clearing
  (p my-results-should-stay
     =goal>
       isa game-state
       state results
       mresult win
       MC1 =c1
       MC2 =c2
       MC3 nil ;;here we make sure that we stayed - then there should not be a c3 drawn
       mtot =tot
     ?imaginal>
       state free
    ==>
     !output! (I WIN)
     =goal>
       state nil
     +imaginal>
       c1 =C1
       c2 =c2
       tot =tot
       action "s") 

  ;; we encode the opponents actions as our own
  ;; this way we get twice the learned info per game
  (p opp-results-should-stay
     =goal>
       isa game-state
       state results
       oresult win
       oC1 =c1
       oc2 =c2
       oc3 nil ;; again we ensure the player stayed by c3
       otot =tot
     ?imaginal>
       state free
    ==>
     =goal>
       state results
     +imaginal>
       C1 =c1
       c2 =c2
       tot =tot
       action "s") 
  
  ;; clearing the imaginal chunk to send the info into the dm
  (p clear-new-imaginal-chunk
     ?imaginal>
       state free
       buffer full
     ==>
     -imaginal>)
  )

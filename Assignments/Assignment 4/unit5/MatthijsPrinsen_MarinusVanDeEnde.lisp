;; Matthijs Prinsen & Marinus v/d Ende
;; Todo: 
;; 1. read opponents cards and encode them
;; 1a. read cards
;; 1b. eval action opponent
;; 1c. encode action + card opp.
;; 2. improve rules 
;; 3. use spreading activation to allow for near misses
;; 4. also save mc2 and oc2
;; 5. add 'fuck it' production to hit when unsure 
;; 6. add 'pussy out' production to hit when unsure 

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
  (chunk-type learned-info mc1 mc2 oc1 oc2 action)
  
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
    ==>
     =goal>
       state retrieving
     +retrieval>
       isa learned-info
       MC1 =c1
       MC2 =c2
     - action nil)

  ;; if there is no previous action we stay
  (p cant-remember-game
     =goal>
       isa game-state
       state retrieving
       MC1  =c1 
       MC2  =c2
     ?retrieval>
       buffer  failure
     ?manual>
       state free
    ==>
     =goal>
       state nil
     +manual>
       cmd press-key
       key "s"
     +imaginal>
       action "s"
       mc1 =c1
       mc2 =c2) ;; DOES THIS GIVE A LENIANCY TO STAY? 
       ;; WE ARE CURRENTLY STAYING WHEN WE DON'T REMEMBER ANYTHING... SHOULD THERE BE ANOTHER P FOR RANDOM HIT?
  
  ;; if we do have a fact retrieved about the current card,
  ;; we execute that strategy
  (p remember-game
     =goal>
       isa game-state
       state retrieving
       mc1 =c1
       mc2 =c2
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
      MC1 =c1
      MC2 =c2
     @retrieval>)
  
  ;; we encode that we should hit when seeing this first card 
  (p my-results-should-hit
     =goal>
       isa game-state
       state results
       mresult =outcome
       MC1 =c
     ?imaginal>
       state free
    ==>
     !output! (I =outcome)
     =goal>
       state opp-results
     +imaginal>
       MC1 =c 
       action "h")
       
  ;; hitting is a highly preferred action with a utility of 10
  (spp results-should-hit :u 10)

  ;; we encode the opponents results too,
  ;; we can base our next action of this  
  (p opp-results-should-hit
     =goal>
       isa game-state
       state opp-results
       oresult win
       oC1 =c1
       oc2 =c2
     ?imaginal>
       state free
    ==>
     =goal>
       state nil
     +imaginal>
       oc1 =C1
       oc2 =c2 
       action "h")

  ;; we encode that we should stay when seeing this first card 
  (p my-results-should-stay
     =goal>
       isa game-state
       state results
       mresult =outcome
       MC1 =c1
       MC2 =c2
       MC3 nil ;;here we make sure that we stayed - then there should not be a c3 drawn
     ?imaginal>
       state free
    ==>
     !output! (I =outcome)
     =goal>
       state nil
     +imaginal>
       MC1 =C1
       MC2 =c2
       action "s") 

  ;; we encode that, when seeing the opponents first card, we should stay too 
  (p opp-results-should-stay
     =goal>
       isa game-state
       state results
       oresult win
       MC1 =c1
       mc2 =c2
     ?imaginal>
       state free
    ==>
     =goal>
       state nil
     +imaginal>
       MC1 =c1
       mc2 =c2
       action "s") 
  
  ;; clearing the imaginal chunk to send the info into the dm
  (p clear-new-imaginal-chunk
     ?imaginal>l
       state free
       buffer full
     ==>
     -imaginal>)
  )

;;WHAT ABOUT A PRODUCTION THAT REPEATS THE CONCEPTS LEARNED UP TILL NOW
;;A PERSON LERANING BLACKJACK WOULD CONTINUESLY REVIEW WHAT THEYVE LEARNED
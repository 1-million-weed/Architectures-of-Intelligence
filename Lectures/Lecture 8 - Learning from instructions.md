---
tags:
  - _FirstPass
  - Marinus
  - Lectures
---

I missed the first 10 minutes 

- she was yapping about how we are able to learn
- we cant just make more productions
- but we could listen to what someone says and then encode that in declarative memory
- she spoke about having a `precondition` then an `action`  then a `postcondition`

- we can combine productions that do multiple things in one production.
	- got to this point by breaking up a production that checks what task we are doing, retrieves it from DM then another production fires but we do all that in one condition now.
- combining these productions result in closely corolated latency and accuracy to humans so it is safe to assume that this is an accurate way of learning over time

1. encode instructions
2. use general instruction-interpreet productions rules
3. over time the model learns to combine productions (idk how this would work in ACT-R)
![[Pasted image 20241205111332.png]]

# Cognitive Control and the Minimal Control Principle

- what is cognitive control?
	- goal states modulate cognitive control to keep track of your tasks

## cognitive control in psychology 

- Executive system 
	- theorized cognitive system in psychology that controls and manages other cognitive processes.
- we use this is new situations, during dangerous activities, and overcome a strong habitual response, 
- anytime the action is not a cognitive response, we use cognition control 
- others:
	- metacognition
	- central executive
	- etc

## What is the problem of the standard definition of control
- what is driving us?
	- a tiny person in our brain?
	- but they have a brain?
	- so who controls them?
- we use cognitive models to simulate cognitive control and how that affects the model overall
	- the example of the tiny person control us is a good analogy for cognitive control 
		- what to concentrate on


- shes now looking at the tradeoffs for a maximal control model
	- there are clearly some drastic cons
	- you cannot break of the system
	- incredibly brittle
- now on the other hand  #embedded_cognition
	- absorb information from the world to know what to do next.
	- minimal control 
		- in unit 2
			- maximal control 
			- it is possible to do all tutorial units without the goal buffer at all
			- if i have visual stimulus do this or that
			- i asked a dumb question....
			- Matthijs gave me the side eye
			- oop
- patterns of lag in act-r are a reason for us using serial productions or thought patterns instead of parallel

- shes talking about aural/visual cognition control overlap.
- we dont want to separate the two tasks, so we just remove the states completely and move purely on out environment
- we group things together 
	- so we know if we hear something, we do something with that
	- #minimal_control_principle
- Second problem with predefined cognitive control: How to order the steps?
	- steps can be ordered in a lot of ways 
	- but there is only one order that eliminates the waiting time the model would have that humans dont really
	- humans dont think about the order
	- how do we get to the optimal outcome?
	- think of steps as actions 
	- prompted by preconditions
	- stored in DM
	- executes when matched.
		- used for visual input, aural input, determined pattern, determined pitch, finger, speak
	- if we look at the production lines, we can see white gaps that are time gaps where we wait for other tasks to finish 
	- to get rid of this wait time, we compile production rules which then takes a lot less time resulting in a much more efficient trace through tasks
	- now if we separate aural and visual, the white spaces are gone


- Pre-specifying top-down control in concurrent multitasking is very hard
- leads to brittle behaviour
- Learning bottom- up automatically find the solution. somehow, check slides 

#  All together: Programming the flight management system (FMS)

- pilots spend a lot of time in classrooms to learn the FMS
	- need to know 25 of the 102 procedures
	- assumed they can infer the rest 
- then the simulator
- then real life (co-pilot first)
- they forget steps when they move to the procedure
- cannot generalise
- shes showing us a hud of a flight simulation and interface
- first left hand key is L1


- i clocked out 
- planning december trip

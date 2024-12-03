---
tags:
  - _FirstPass
  - Lectures
  - Marinus
---
> I missed the first 15 minutes

# Phases of skill acquisition

- spoke about 3 in act-r

Fits & Psner 
- Cognitive
- associative
- autonomous - not even thinking baout it anymore

in ACT-R
- Declarative = cognitive 
- associative - skip to end and call outcome
- procedural - 

We need to recognise these phases from graphs
- look for discontinuities in what should be a nice curve
- a distinct drop
- some spots where performance decreases then increases 
	- this is the swtiching 

## Why do we need procedural memory 

- Declarative memroy
	- regrieval is time consuming and error-prone
	- less general
	- can be articulated
- procedural knowledge
	- executes at low cost and low risk for error
	- often general
	- more unconscious (like riding a bike) muscle memory

## How do we move between stages

- see something baough times, build up memory to move to stage 2
	- instance based learning
- from 2 to 3 
	- next points

# Production utility in act-r

- for conflict resolution
- reslistically, there are multiple things we can do in one moment
	- weve only written procedural productions that fire if we simply have the right condiitons
	- but realistically we have multiple things we can do at once
- dont memorise equations but know latency depends on acitvation of chunks
	- know the theory behind the equations but not the equation itsself

# Example probability matching

- have a look at the slides
- but we get an inate sense about which option has a reward
- and we will select the button we have a feeling will have the most chance of giving a reward

> Check canvas, there are some notes there

# Utility learning in ACT-R

- long equation
- $$
U_i(n) = U_i(n-1) + \alpha \big[R_i(n) - U_i(n-1)\big]
$$

Where:
- $(U_i(n)):$ Utility at application $(n)$
- \( U_i(n-1) \): Utility at application \( n-1 \)
- \( \alpha \): Learning rate
- \( R_i(n) \): Reward at application \( n \)
- \( \big\[R_i(n) - U_i(n-1)\big\] \): Difference between the current utility and reward

# Choise rules

- actually just look at the code on the slides.
- shes yapping about what the code does


# Connectionist Theory

- how doe people learn the english past tense
	- some debate but not sure why. lecturers notes
- The big debate
	- Symbolic Rules vs. Connectionist Network
	- stage 1: high accurace
	- stage 2: lower 
	- stage 3: high 
	- difference comes from different ways to solve these problems
	- we applly or missaply some rule like adding "-ed" to the end of verbs for past tense although it is not needed.
- U-shaped learning is explained by the learning 
- we make mistaked when the neural representation becomes to complex 
- feature mapping makes sense wehre we use similar three letter representations to create maps of the past tense variants.
- the connectionist theory is that there are overlaps between too many new words and they conflict pathways between correct present-past tense 

## Problems

- relies on sudden increase in words
	- little evidence that growth of vocab and overregulation coincide in children
- produces too many errors
- only works when regular verbs are a majority

So why is there is adifference between regular and irregular verbs???
- Regular words
	- Advantage: very productive (only one rule)
	- Disadvantage: tend to be longer (-ed added)
- Irregular verbs:
	- Advantage: shorter, faster to produce 
	- Disadvantage: have to be memorised 

# Discussions about modelling verb learning in ACT-R

- describing learning logic about new past tense verbs like:
  if we have work-worked and we dont have break
  we might as well make the assumption that we can make breaked
- production compilation 
	- slide 101
	- if two rules fire in sequence we can combine them into one rule

- irregular verbs are shorter and faster to say so their utility will increase much faster 
- new rules need to be called multiple times to start competing for utility

# 21 can you do some for me 
- the model needs to learn over time
- it knows the rules but has no experience 
- the oponent has a fixed strat

- need to use partial matching
- at the end of each round the model learns a new chunk and also what it should have done



# We winnnn Cakkkkeeeeee Yum


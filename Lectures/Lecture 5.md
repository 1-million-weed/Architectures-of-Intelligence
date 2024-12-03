---
tags:
  - _FirstPass
  - Lectures
  - Marinus
---

I missed the first 20 mintes.


# Looking at ACT-R

- Declarative Memory
- ACT-R Deals with everything with an activation function $$A_i=B_i+C_i+M_i+e$$Some weird noise term
	- $A_i :$ estimates odds that a fact is needed in the current context
	- B: Base level activation (activation of chunk i)
	- $C_i:$ In fluence of context
	- $M_i:$ Mismatch penelty
	- e: Noise in the brain
	- $\tau$ Determines our retrieval threshold activation
---
- Odds: $$odds=\frac{p}{1-p}$$
 - For a single chunk: $$Odds_i(t)=(t-t_i)^{-d}$$
 - Presentations become additive: $$Odds_i(t)=\sum_{k=1}^{n}(t-t_i)^{-d}$$
 - Fully compute this out, for every chunk $$B_i(t)=ln(\sum_{k=1}^{n}(t-t_i)^{-d})$$
	 - $n:$ Amount of presentations
	 - $(t-t_k):$ Time since $n^{th}$ presentation
	 - $-d:$ Decay parameter
	- With this function, ACT-R has to calculate the activity of matching chunks.
	- computationally expensive
	- implies brain has access to all this
- #_FirstPass insert optimised equation

# Recall Probability
$$pr_i=\frac{1}{1+e^{\frac{\tau -A_i}{s}}}$$
- s: term that defines distribution that you are drawing the graph from
- ![[Pasted image 20241125094154.png]]
- The smaller the noise gets the more pointy the activation curve gets:![[Pasted image 20241125094432.png]]
# Parameters

- enable subsymbolic computation `esc nil or t`
- optimised learning: `:ol nil, t, >0`
- Retrieval threshold: `:rt#`

# Results

- like everything is on the slides. taking notes of all this is seriously cognitively taxing
- were talking about pairs from the imaginal buffers
- saw something weird thouhg
	- after the ==> she has ` =imaginal answer =val`  

# Fitting the model 
- A lot of yaps about fitting a model
- honestly clocked out
- watched arcane till 2:30. i am tired

# Assignment

- make a model that can answer these questions:
	- B+2=D
		- B incremented by 2 is D
	- C+4=F
		- This is incorrect
	- When shown one of these equations, we need to say if the equations is correct.
- How do we solve this problem??
	- what method are we using?
		- counting the alphabet
		- also, you might reach a point where you just know
	- counting always works but its slow
	- it will always take longer the more items we have to count
	- retrieval is fast but we first need the facts
	- Speed is now based on frequency, and not on amount of counting
- read unit 4 in the reader
- aight. im out. commit and ommit. yeet
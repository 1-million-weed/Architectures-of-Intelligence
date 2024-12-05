---
tags:
  - Matthijs
  - _FirstPass
  - Lectures
---
# 20 questions
- Newell: "You can't play 20 questions with nature and win"
- Referring to the many phenomena in nature 
	- Too many to narrow down in 20 Q's
	- We should not be looking at individual phenomena

## Two main problems
1. Explanations are too vague
2. Isolated phenomena (no overall theory)

# 1. Explanations are too vague
The explanations of the mind are too vague, how do we make them concrete?

We need **a computational model**
However, computers are too powerful!

Solution: A **cognitive** computational model

![[Pasted image 20241204135443.png]]
The flowchart is a cognitive psychological model made by Clark & Chase. _This was deemed too vague by Newell_

# What makes a good model?
e.g. a self driving car (2 videos linked in the lecture slides)

Humans have different levels of brain activity during driving alone versus driving while listening

A car driving model should do:
1. Drive a car
2. Drive a car like a human (*such that for instance its lateral deviation matches human behaviour when operating a cell phone*)
3. Show how brain activation related to driving decreases when it talks on a cell phone

From this we construed the following list:
- **Functional criteria**
	- The model has to be able to show intelligent behaviour appropriate for the task
-  **Behavioural criteria**
	- The model has to perform the task in the same way as humans
- **Neurophysiological criteria**
	- The model has to be faithful to what happens in the brain
		- Use of neural networks or neural representations
		- Be able to predict brain activation

Balancing the two aspects:
1. Functionality
2. Theory

So, as an answer to problem 1 : **Cognitive Models**

### Connectionism - connecting theory to brain
1. Nengo: low level architecture - start with neurons
2. Act-r: high level architecture - Model regions, measure activity
- Combine the two:
**Neural networks**: implementation of high level architecture

## Problem II: Isolated phenomena: 
no overall theory

Research is aimed at individual phenomena and not at the overall theory underlying the human brain.
phenomena like:
- Visual search
- Working Memory size
- Visual processing speed
- Switch tasks
- Timing
- etc.
### Newell’s solution:
1. Study large, real-life tasks, and understand all aspects of that task (example: chess, driving)
2. Combine separate models in a cognitive architecture

#_FirstPass start from slide 30/62
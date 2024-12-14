---
tags:
  - _FirstPass
  - Marinus
  - Lectures
---
I missed like the first 5 minutes. im still recovering, i made it here in about 12 minutes with a stop at the plus on the way.

Yapped about should we simulate the brain down to the neuron level
- i gave reasons
	- have to simulate the hormone interactions
	- what the different neurons do
- Lecturer is being autistic
	- my neurons are firingg
	- making my brain think
	- making my tongue move
	- ... bruh

What we want to do is explain higher-level phenoomena based on lower-level biological constraints

yapped about the more tests you can do on your model the more accurate. asked the question that if a super complex model with 800k neurons is the right one?

wants to develop neuron specific algorithms, so things that neurons are good as, then put those into an app and then you can use the algorithms to build your own models.

# Spiking neurons

Shows a video by nature about a mouse cortex that they scanned slice by slice

- using traditional artificial neurons(sigmoid shape, continuous) nope nvm
- we use the spiking neurons ~ nengo ~ fuck me in the ass

- helpfull book: how to build a brain. 
	- we need to read about 3 chapters of this book for the exam
- chrisy boi
- what i cannot create i do not understand
	- we have to test and create our ideas to understand things

## values

Leaky integrate-and-fire neuron
- other more complex:
	- adaptive LIF
	- Izhikevich
	- Hodgkin-Huxley
- maybe ask the uni for some supercomputer time 
	- they set up a model with 800k neurons on a server with 500gb ram and it took a whole day to simulate an hours worth of participant interactions.
- hes basically saying the more neurons you have the best 
	- rule of thumb 50 neurons per value
- we are now in nengo, pretty cool
- runs in python
- import nengo 
```python
import nengo

a = nengo.Ensamble(n_neurons=1, dimensions=1)
```
- hes explaining what the tuning curve threshold represents and changes when you change it. 
- moving to 2 neurons now

continue on ipad. laptop dead

## represent

## store

# How to build a brain
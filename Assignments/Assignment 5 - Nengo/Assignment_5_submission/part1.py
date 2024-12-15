# Matthijs Prinsen (S4003365)
# Marinus v/d Ende (s5460484)

import nengo
import numpy as np # imported numpy for the sine function

model = nengo.Network()
with model:

    def sin_func(t): # define the sine stimulus function
        return np.sin(2*t)
    
    def compute_square_center(x):
        return x*x-.5 # defing the a to b connection function centering around 0
     
    stim = nengo.Node(sin_func) # Stimulus - set to 0 will give a 0 stimulus
    
    a = nengo.Ensemble(n_neurons=100, dimensions=1) # neuron ensembles with n=100
    b = nengo.Ensemble(n_neurons=100, dimensions=1)
    c = nengo.Ensemble(n_neurons=100, dimensions=1)
    d = nengo.Ensemble(n_neurons=100, dimensions=2) # 2 dimensions for xy values
    
    nengo.Connection(stim, a) # connecting the stimulus to a
    nengo.Connection(a, b, function=compute_square_center) # connecting a to b function
    nengo.Connection(b, c, transform=.5) # reducing the signal to half
    nengo.Connection(c, d[0]) # connect output of C to input D[0]
    nengo.Connection(c, c, synapse=.1) # node c remembers at 100 ms delay
    nengo.Connection(stim, d[1]) # connecting the stimulus to input d[1]

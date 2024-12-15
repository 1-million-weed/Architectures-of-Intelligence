# Matthijs Prinsen (s)
# Marinus v/d Ende (s5460484)

import nengo
import numpy as np
import matplotlib.pyplot as plt

model = nengo.Network()
with model:
    # The sine function
    def sin_func(t):
        return np.sin(1*t)

    # Stimulus - adjustable with slider
    stim = nengo.Node(sin_func)
    # Neuron ensamble A
    a = nengo.Ensemble(n_neurons=100, dimensions=1)
    # stimulus to esamble A connection
    nengo.Connection(stim, a)
    
    # Function for squaring an input
    def square_center(x):
        return (x * x) - .5
    
    # oh no i changed something
    
    # Neuron ensamble B
    b = nengo.Ensemble(n_neurons=100, dimensions=1)
    # ensamble a to b with function 
    nengo.Connection(a, b, function=square_center)
    
    # Neuron ensamble C
    c = nengo.Ensemble(n_neurons=100, dimensions=1)
    # ensamble b to c connection halved
    nengo.Connection(b, c, transform=.5)
    # Simmple memory for the C output value 
    nengo.Connection(c, c, synapse=0.1)
    
    ### PART 1 DONE ###
    
    # Neuron ensamble D
    d = nengo.Ensemble(n_neurons=100, dimensions=1, radius=1)
    # sine of stimulus to ensamble D
    nengo.Connection(stim, d, function=sin_func)
    # ensamble C to ensamble D
    nengo.Connection(c, d)
    
    plt.figure() 
    
    
    
    
    
    
    
    
    
    
    
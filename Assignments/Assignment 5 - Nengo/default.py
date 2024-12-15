import nengo
import numpy as np #imported numpy for the sine function

model = nengo.Network()
with model:
    def sin_func(t):
        return np.sin(2*t) #here we define the stimulus function
    stim = nengo.Node(sin_func) #changing sin_func to 0 will give a 0 stimulus
    a = nengo.Ensemble(n_neurons=100, dimensions=1) #neuron ensembles with n=100
    b = nengo.Ensemble(n_neurons=100, dimensions=1)
    c = nengo.Ensemble(n_neurons=100, dimensions=1)
    d = nengo.Ensemble(n_neurons=100, dimensions=2) #2 dimensions for xy values
    nengo.Connection(stim, a)
    def func(x):
        return x*x-.5 #defing the a to b connection function centering around 0
    nengo.Connection(a, b, function=func)
    nengo.Connection(b, c, transform=.5) #reducing the signal to half
    nengo.Connection(c, d[0]) #here we connect c to 1 of the d dimensions
    nengo.Connection(c, c, synapse=.1) #node c remembers at 100 ms delay
    nengo.Connection(stim, d[1]) #connecting the stimulus to d's other dimension

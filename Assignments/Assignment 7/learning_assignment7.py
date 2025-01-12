import nengo
import numpy as np

model = nengo.Network()
with model:
    
    #stimulus node, with fast sine
    stim = nengo.Node(lambda t: np.sin(t*2*np.pi))
    
    #non-learning part
    pre = nengo.Ensemble(n_neurons=10, dimensions=1)
    post = nengo.Ensemble(n_neurons=10, dimensions=1)
    nengo.Connection(stim, pre) #stim -> pre
    nengo.Connection(pre, post) #pre -> post
    
    #learning part 
    # ...
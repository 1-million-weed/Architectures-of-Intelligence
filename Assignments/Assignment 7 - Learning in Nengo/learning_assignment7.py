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
    pre_learning = nengo.Ensemble(n_neurons=10, dimensions=1)
    post_learning = nengo.Ensemble(n_neurons=10, dimensions=1)
    nengo.Connection(stim, pre_learning)
    
    learning_connection = nengo.Connection(pre_learning, post_learning, 
        solver=nengo.solvers.LstsqL2(weights=True))
        
#build model without actually running it 
with nengo.simulator.Simulator(model, progress_bar=False) as weights_sim: 
    pass

#get weights and print 
weights = weights_sim.data[learning_connection].weights 
print(weights)
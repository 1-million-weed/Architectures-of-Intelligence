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
    nengo.Connection(pre, post, function=lambda x:x**2) #pre -> post
    
    #learning part 
    pre_learning = nengo.Ensemble(n_neurons=10, dimensions=1)
    post_learning = nengo.Ensemble(n_neurons=10, dimensions=1)
    error = nengo.Ensemble(n_neurons=10, dimensions=1)
    nengo.Connection(stim, pre_learning)
    
    learning_connection = nengo.Connection(pre_learning, post_learning, 
        transform=0, learning_rule_type=nengo.PES(learning_rate=1e-4))
    
    # Error = actual - target = post - pre
    nengo.Connection(pre_learning, error, function=lambda x: x**2, transform=-1)
    nengo.Connection(post_learning, error)
    
    # Connect the error into the learning rule
    nengo.Connection(error, learning_connection.learning_rule)
        
#build model without actually running it 
with nengo.simulator.Simulator(model, progress_bar=False) as weights_sim: 
    pass

#get weights and print 
weights = weights_sim.data[learning_connection].weights 
print(weights)
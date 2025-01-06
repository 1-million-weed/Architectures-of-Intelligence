import nengo
import nengo.spa as spa
import numpy as np

from nengo.spa.module import Module
from nengo.spa.compare import Compare

class CompareAccumulator(Compare):
    """A module for computing the dot product of two inputs, now including:
    a) cleanup memories before comparison
    b) accumulator to judge outcome. Accumulates negatively when inputs are dissimilar.

    Parameters - for accumulation & cleanup memories
    ----------
    vocab : 
        The vocabulary to use to interpret the vector. If None,
        the default vocabulary for the given dimensionality is used.
    
    status_scale = .8 #speed of accumulation
    status_feedback = .8 #feedback transformation on status
    status_feedback_synapse = .1 #feedback synapse on status
    threshold_input_detect = .5 #threshold for input to be counted
    pos_bias = 0, added weight for positive evidence 
    
    threshold_cleanup=.3, threshold cleanup memories
    wta_inhibit_scale_cleanup=3, wta inhibit scale of cleanup memories
    
    
    Parameters - for compare
    ----------

    neurons_per_multiply : int, optional (Default: 200)
        Number of neurons to use in each product computation.
    input_magnitude : float, optional (Default: 1.0)
        The expected magnitude of the vectors to be multiplied.
        This value is used to determine the radius of the ensembles
        computing the element-wise product.

    label : str, optional (Default: None)
        A name for the ensemble. Used for debugging and visualization.
    seed : int, optional (Default: None)
        The seed used for random number generation.
    add_to_container : bool, optional (Default: None)
        Determines if this Network will be added to the current container.
        If None, will be true if currently within a Network.
    """

    def __init__(self, vocab_compare, status_scale=.8, status_feedback=.6, status_feedback_synapse=.1, pos_bias=0, neg_bias=0, threshold_input_detect=.5, threshold_cleanup=.3, wta_inhibit_scale_cleanup=3, **kwargs):
        
        dimensions = vocab_compare.dimensions
        super(CompareAccumulator, self).__init__(dimensions, vocab=vocab_compare, **kwargs)

        with self:
        
            #clean up memories for input, to enable clean comparison
            self.cleanup_inputA = spa.AssociativeMemory(input_vocab=vocab_compare, wta_output=True, threshold=threshold_cleanup, wta_inhibit_scale=wta_inhibit_scale_cleanup)
            self.cleanup_inputB = spa.AssociativeMemory(input_vocab=vocab_compare, wta_output=True, threshold=threshold_cleanup, wta_inhibit_scale=wta_inhibit_scale_cleanup)
            nengo.Connection(self.cleanup_inputA.output,self.inputA)
            nengo.Connection(self.cleanup_inputB.output,self.inputB)

            #compare status indicator
            self.comparison_status = nengo.Ensemble(50,1)
            nengo.Connection(self.comparison_status,self.comparison_status, transform=status_feedback, synapse=status_feedback_synapse)
              
            #positive source
            nengo.Connection(self.output, self.comparison_status, transform=status_scale+pos_bias)
        
            #detect when input present on both inputs
            n_signal = min(50,dimensions) #number of random dimensions used to determine whether input is present
    
            #inputA
            self.switch_inA = nengo.Ensemble(n_neurons=n_signal*50,dimensions=n_signal,radius=1) #50 neurons per dimension
            nengo.Connection(self.cleanup_inputA.input[0:n_signal], self.switch_inA, transform=10, synapse=None) #no synapse, as input signal directly 

            #inputB
            self.switch_inB = nengo.Ensemble(n_neurons=n_signal*50,dimensions=n_signal,radius=1) #50 neurons per dimension
            nengo.Connection(self.cleanup_inputB.input[0:n_signal], self.switch_inB, transform=10, synapse=None) #no synapse, as input signal directly 

            #combine evidence
            self.switch_detect = nengo.Ensemble(n_neurons=500,dimensions=2,radius=1.4)
            nengo.Connection(self.switch_inA, self.switch_detect[0],function=lambda x: np.sqrt(np.sum(x*x)),eval_points=nengo.dists.Gaussian(0,.1))
            nengo.Connection(self.switch_inB, self.switch_detect[1],function=lambda x: np.sqrt(np.sum(x*x)),eval_points=nengo.dists.Gaussian(0,.1))

            #negative source
            self.negative_source = nengo.Ensemble(n_neurons=100,dimensions=1)

            nengo.Connection(self.switch_detect, self.negative_source, function=lambda x: 1 if x[0]*x[1] > threshold_input_detect else 0)
            nengo.Connection(self.negative_source, self.comparison_status, transform=-(status_scale/2)-neg_bias)

            #inhibit when no input - doesn't work well cause it's also dependent on input
            def inhibit_function(x):
                if x[0]*x[1] > threshold_input_detect:
                    return 0
                else:
                    return np.ones((self.comparison_status.n_neurons))
            nengo.Connection(self.switch_detect, self.comparison_status.neurons, function=inhibit_function, transform=-1, synapse=0.005)
        


            #bias
            #nengo.Connection(self.negative_source, self.comparison_status, transform=bias)
            
            #outputs we can use on LHS
            self.outputs['status'] = (self.comparison_status,1)
            
            #input for RHS
            self.inputs['cleanA'] = (self.cleanup_inputA.input, vocab_compare)
            self.inputs['cleanB'] = (self.cleanup_inputB.input, vocab_compare )            
            



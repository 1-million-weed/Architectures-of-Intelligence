import nengo
import nengo.spa as spa
import numpy as np

from nengo.spa.module import Module
from nengo.spa.assoc_mem import AssociativeMemory

class AssociativeMemoryAccumulator(AssociativeMemory):
    """Associative memory module with accumulator that keeps track of retrieval status.

    Parameters - for accumulation
    ----------
    status_scale = .8 #speed of accumulation
    status_feedback = .8 #feedback transformation on status
    status_feedback_synapse = .1 #feedback synapse on status
    bias = 0 # if positive, positive evidence is biased, if negative, negative evidence is biased
    
    Parameters - for defaul associative memory
    ----------
    input_vocab: list or Vocabulary
        The vocabulary (or list of vectors) to match.
    output_vocab: list or Vocabulary, optional (Default: None)
        The vocabulary (or list of vectors) to be produced for each match. If
        None, the associative memory will act like an autoassociative memory
        (cleanup memory).
    input_keys : list, optional (Default: None)
        A list of strings that correspond to the input vectors.
    output_keys : list, optional (Default: None)
        A list of strings that correspond to the output vectors.
    default_output_key: str, optional (Default: None)
        The semantic pointer string to be produced if the input value matches
        none of vectors in the input vector list.
    threshold: float, optional (Default: 0.3)
        The association activation threshold.
    inhibitable: bool, optional (Default: False)
        Flag to indicate if the entire associative memory module is
        inhibitable (i.e., the entire module can be inhibited).
    wta_output: bool, optional (Default: False)
        Flag to indicate if output of the associative memory should contain
        more than one vector. If True, only one vector's output will be
        produced; i.e. produce a winner-take-all (WTA) output.
        If False, combinations of vectors will be produced.
    wta_inhibit_scale: float, optional (Default: 3.0)
        Scaling factor on the winner-take-all (WTA) inhibitory connections.
    wta_synapse: float, optional (Default: 0.005)
        Synapse to use for the winner-take-all (wta) inhibitory connections.
    threshold_output: bool, optional (Default: False)
        Adds a threholded output if True.
    label : str, optional (Default: None)
        A name for the ensemble. Used for debugging and visualization.
    seed : int, optional (Default: None)
        The seed used for random number generation.
    add_to_container : bool, optional (Default: None)
        Determines if this Network will be added to the current container.
        If None, will be true if currently within a Network.
    
    """

    def __init__(self, status_scale=.8, status_feedback=.8,status_feedback_synapse=.1, threshold_input_detect=.6, bias=0, **kwargs):
        super(AssociativeMemoryAccumulator, self).__init__(**kwargs)

        with self:
            #memory status indicator
            self.memory_status = nengo.Ensemble(50,1)
            nengo.Connection(self.memory_status,self.memory_status, transform=status_feedback, synapse=status_feedback_synapse)
            
            #positive source for status accumulator: summed similarity
            self.summed_similarity = nengo.Ensemble(n_neurons=100,dimensions=1)
            
            #original version based on similarity
            #nengo.Connection(self.am.elem_output, self.summed_similarity, transform=np.ones((1, self.am.elem_output.size_out))) #take sum

            #new version based on neural activity
            self.summed_act = nengo.Node(None,size_in=1) #node to collect sum of activity to normalize
        
            #connect all ensembles to summed_act    
            for i, ens in enumerate(self.am.am_ensembles):
                mr = (ens.max_rates.high + ens.max_rates.low)/2 #calc average max rate
                nengo.Connection(ens.neurons, self.summed_act, transform=np.ones((1, ens.n_neurons))/(ens.n_neurons*mr),synapse=None)
            
            nengo.Connection(self.summed_act,self.summed_similarity, transform=1) #connect to summed sim without changing it
            nengo.Connection(self.summed_similarity,self.memory_status, transform=status_scale+bias) #use bias to scale this
        
            #negative source for status: switched on when input present
            n_signal = 10 #number of  dimensions used to determine whether input is present
    
            self.switch_in = nengo.Ensemble(n_neurons=n_signal*50,dimensions=n_signal,radius=1) #50 neurons per dimension
            nengo.Connection(self.am.input[0:10],self.switch_in,transform=10,synapse=None) #no synapse, as input signal directly 

            self.switch_detect = nengo.Ensemble(n_neurons=200,dimensions=1)
            nengo.Connection(self.switch_in,self.switch_detect,function=lambda x: np.sqrt(np.sum(x*x)),eval_points=nengo.dists.Gaussian(0,.1))
    
            self.negative_source = nengo.Ensemble(n_neurons=100,dimensions=1)
            nengo.Connection(self.switch_detect,self.negative_source, function=lambda x: 1 if x > threshold_input_detect else 0,synapse=.05)
            nengo.Connection(self.negative_source, self.memory_status, transform=-((status_scale-bias)/2)) 
 
            #bias
            #nengo.Connection(self.negative_source, self.memory_status, transform=bias)
 
            #outputs we can use on LHS
            self.outputs['status'] = (self.memory_status,1)
            self.outputs['summed_sim'] = (self.summed_similarity,1)

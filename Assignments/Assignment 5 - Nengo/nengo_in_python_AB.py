"""
@author: Jelmer Borst (j.p.borst@rug.nl)
Based on: https://www.nengo.ai/nengo/examples/advanced/nef-algorithm.html

"""

#import necessary libraries
import numpy as np
import matplotlib.pyplot as plt

#defaults for the simulated neurons, you can leave those as they are
dt = 0.001  # simulation time step
t_rc = 0.02  # membrane RC time constant
t_ref = 0.002  # refractory period
t_pstc = 0.1  # post-synaptic time constant
max_rates = 25, 75  # range of maximum firing rates
N_samples = 100  # number of sample points to use when finding decoders


#specifications of neural ensembles: add information for ensembles C and D
N_A = 50  # number of neurons in A
N_B = 40  # number of neurons in B


def input(t):
    """The input to the system over time"""
    return np.sin(t)


def function_AB(x):
    """The function to compute between A and B."""
    return x * x - .5


### 1. Functions for generating ensembles and running the model ###
###################################################################

def generate_gain_and_bias(count, intercept_low, intercept_high, rate_low, rate_high):
    """Prepare neurons by generating gain and bias (see Appendix B of How to build a Brain)"""
    gain = []
    bias = []
    for _ in range(count):
        # desired intercept (x value for which the neuron starts firing)
        intercept = np.random.uniform(intercept_low, intercept_high)
        # desired maximum rate (firing rate when x is maximum)
        rate = np.random.uniform(rate_low, rate_high)

        # this algorithm is specific to LIF neurons, but should
        # generate gain and bias values to produce the desired
        # intercept and rate
        z = 1.0 / (1 - np.exp((t_ref - (1.0 / rate)) / t_rc))
        g = (1 - z) / (intercept - 1.0)
        b = 1 - g * intercept
        gain.append(g)
        bias.append(b)
    return gain, bias

def run_neurons(input, v, ref):
    """Run the neuron model.

    A simple leaky integrate-and-fire model, scaled so that v=0 is resting
    voltage and v=1 is the firing threshold.
    """
    spikes = []
    for i, _ in enumerate(v):
        dV = dt * (input[i] - v[i]) / t_rc  # the LIF voltage change equation
        v[i] += dV
        if v[i] < 0:
            v[i] = 0  # don't allow voltage to go below 0

        if ref[i] > 0:  # if we are in our refractory period
            v[i] = 0  # keep voltage at zero and
            ref[i] -= dt  # decrease the refractory period

        if v[i] > 1:  # if we have hit threshold
            spikes.append(True)  # spike
            v[i] = 0  # reset the voltage
            ref[i] = t_ref  # and set the refractory period
        else:
            spikes.append(False)
    return spikes


def compute_response(x, encoder, gain, bias, time_limit=0.5):
    """Measure the spike rate of a population for a given value x."""
    N = len(encoder)  # number of neurons
    v = [0] * N  # voltage
    ref = [0] * N  # refractory period

    # compute input corresponding to x
    input = []
    for i in range(N):
        input.append(x * encoder[i] * gain[i] + bias[i])
        v[i] = np.random.uniform(0, 1)  # randomize the initial voltage level

    count = [0] * N  # spike count for each neuron

    # feed the input into the population for a given amount of time
    t = 0
    while t < time_limit:
        spikes = run_neurons(input, v, ref)
        for i, s in enumerate(spikes):
            if s:
                count[i] += 1
        t += dt
    return [c / time_limit for c in count]  # return the spike rate (in Hz)


def compute_tuning_curves(encoder, gain, bias):
    """Compute the tuning curves for a population"""
    # generate a set of x values to sample at
    x_values = [i * 2.0 / N_samples - 1.0 for i in range(N_samples)]

    # build up a matrix of neural responses to each input (i.e. tuning curves)
    A = []
    for x in x_values:
        response = compute_response(x, encoder, gain, bias)
        A.append(response)
    return x_values, A


def compute_decoder(encoder, gain, bias, function=lambda x: x):
    """Compute decoders based on tuning curves and function"""
    # get the tuning curves
    x_values, A = compute_tuning_curves(encoder, gain, bias)

    # get the desired decoded value for each sample point
    value = np.array([[function(x)] for x in x_values])

    # calculate the optimal linear decoder
    A = np.array(A).T
    Gamma = np.dot(A, A.T)
    Upsilon = np.dot(A, value)
    Ginv = np.linalg.pinv(Gamma)
    decoder = np.dot(Ginv, Upsilon) / dt
    return decoder



### 2. Generating the ensembles and connections ###
###################################################

# get random gain and bias for the two populations
gain_A, bias_A = generate_gain_and_bias(N_A, -1, 1, max_rates[0], max_rates[1])
gain_B, bias_B = generate_gain_and_bias(N_B, -1, 1, max_rates[0], max_rates[1])

# create random encoders for the two populations
encoder_A = [np.random.choice([-1, 1]) for i in range(N_A)]
encoder_B = [np.random.choice([-1, 1]) for i in range(N_B)]

# find the decoders for A and B
decoder_A = compute_decoder(encoder_A, gain_A, bias_A) #only to look at the represented value in A
decoder_B = compute_decoder(encoder_B, gain_B, bias_B)

# Compute the weight matrix:
# calculate decoders for A with the square func
decoder_AB = compute_decoder(encoder_A, gain_A, bias_A, function=function_AB)

# & combine with encoders for B
weightsAB = np.dot(decoder_AB, [encoder_B])



### 3. Running the simulation ###
#################################

v_A = [0.0] * N_A  # voltage for population A
ref_A = [0.0] * N_A  # refractory period for population A
input_A = [0.0] * N_A  # input for population A

v_B = [0.0] * N_B  # voltage for population B
ref_B = [0.0] * N_B  # refractory period for population B
input_B = [0.0] * N_B  # input for population B

# scaling factor for the post-synaptic filter
pstc_scale = 1.0 - np.exp(-dt / t_pstc)

# for storing simulation data to plot afterward
times = []
ideal_A = []
output_A = 0.0  # the decoded output value from population A
outputs_A = []

ideal_B = []
output_B = 0.0  # the decoded output value from population B
outputs_B = []

t = 0
while t < 10.0: 
    
    
    ## Ensemble A
    
    # call the input function to determine the input value for A
    x = input(t)

    # convert the input value into an input for each neuron
    for i in range(N_A):
        input_A[i] = x * encoder_A[i] * gain_A[i] + bias_A[i]

    # run population A and determine which neurons spike
    spikes_A = run_neurons(input_A, v_A, ref_A)

    # for each neuron in A that spikes, update our decoded value for plotting
    # (also applying the same post-synaptic filter; not used in simulation)
    output_A *= 1.0 - pstc_scale
    for j, s in enumerate(spikes_A):
        if s:
            output_A += decoder_A[j][0] * pstc_scale


    ## Ensemble B

    # Calculate input for B
    
    # decay all of the previous inputs (implementing the post-synaptic filter)
    for j in range(N_B):
        input_B[j] *= 1.0 - pstc_scale
       
    # for each neuron that spikes in A, increase the input current
    # of all the neurons it is connected to by the synaptic
    # connection weight
    for i, s in enumerate(spikes_A):
        if s:
            for j in range(N_B):
                input_B[j] += weightsAB[i][j] * pstc_scale

    # compute the total input into each neuron in population B
    # (taking into account gain and bias)
    total_B = [0] * N_B
    for j in range(N_B):
        total_B[j] = gain_B[j] * input_B[j] + bias_B[j]

    # run population B and determine which neurons spike
    spikes_B = run_neurons(total_B, v_B, ref_B)

    # for each neuron in B that spikes, update our decoded value
    # (also applying the same post-synaptic filter)
    output_B *= 1.0 - pstc_scale
    for j, s in enumerate(spikes_B):
        if s:
            output_B += decoder_B[j][0] * pstc_scale

        
            
    ## Save for plotting:
    times.append(t)
    
    ideal_A.append(x)
    outputs_A.append(output_A)

    ideal_B.append(function_AB(x))
    outputs_B.append(output_B)

    # output
    if t % 0.5 <= dt:
        print(t)
    t += dt



### 4. Plot the results ###
###########################


# Check tuning curves for one population
x, A = compute_tuning_curves(encoder_A, gain_A, bias_A)

plt.figure()
plt.plot(x, A)
plt.title("Tuning curves for population A")


# Simulation results

plt.figure()
plt.plot(times, ideal_A, label="ideal_A")
plt.plot(times, outputs_A, label="A")
plt.plot(times, ideal_B, label="ideal_B")
plt.plot(times, outputs_B, label="B")
plt.title("Simulation results")
plt.legend()
plt.show()


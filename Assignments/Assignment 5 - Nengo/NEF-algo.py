# This is based on the NEF documentation: 
# https://www.nengo.ai/nengo/examples/advanced/nef-algorithm.html

import math
import random

import numpy
import matplotlib.pyplot as plt

dt = 0.001          # simulation time step
t_rc = 0.02         # membrane RC time constant
t_ref = 0.002       # refractory period
t_pstc = 0.1        # post-synaptic time constant
N_A = 50            # number of neurons in first population
N_B = 40            # number of neurons in second population
N_samples = 100     # number of sample points to use when finding decoders
rate_A = 25, 75     # range of maximum firing rates for population A
rate_B = 50, 100    # range of maximum firing rates for population B


def input(t):
    """The input to the system over time"""
    return math.sin(t)


def function(x):
    """The function to compute between A and B."""
    return x * x

# create random encoders for the two populations
encoder_A = [random.choice([-1, 1]) for _ in range(N_A)]
encoder_B = [random.choice([-1, 1]) for _ in range(N_B)]

def generate_gain_and_bias(count, intercept_low, intercept_high, rate_low, rate_high):
    gain = []
    bias = []
    for _ in range(count):
        # desired intercept (x value for which the neuron starts firing)
        intercept = random.uniform(intercept_low, intercept_high)
        # desired maximum rate (firing rate when x is maximum)
        rate = random.uniform(rate_low, rate_high)

        # this algorithm is specific to LIF neurons, but should
        # generate gain and bias values to produce the desired
        # intercept and rate
        z = 1.0 / (1 - math.exp((t_ref - (1.0 / rate)) / t_rc))
        g = (1 - z) / (intercept - 1.0)
        b = 1 - g * intercept
        gain.append(g)
        bias.append(b)
    return gain, bias

# random gain and bias for the two populations
gain_A, bias_A = generate_gain_and_bias(N_A, -1, 1, rate_A[0], rate_A[1])
gain_B, bias_B = generate_gain_and_bias(N_B, -1, 1, rate_B[0], rate_B[1])

def run_neurons(input, v, ref):
    """Run the neuron model.

    A simple leaky integrate-and-fire model, scaled so that v=0 is resting
    voltage and v=1 is the firing threshold.
    """
    spikes = []
    for i, vi in enumerate(v):
        dV = dt * (input[i] - vi) / t_rc  # the LIF voltage change equation
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
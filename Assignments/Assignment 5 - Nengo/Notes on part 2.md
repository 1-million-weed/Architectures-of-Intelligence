---
tags:
  - Marinus
  - Assignments
Date: 2024-12-15
---
# Run Neurons

The below code links back to the the book [HtBaB](Resources/How_to_Build_a_Brain.pdf) page 396
```python
dV = dt * (input[i] - v[i]) / t_rc  # the LIF voltage change equation
v[i] += dV
```
![[B3.png]]

The rest of the if functions it that function are self explanatory.

# Compute Responses

```python
    # compute input corresponding to x
    input = []
    for i in range(N):
        input.append(x * encoder[i] * gain[i] + bias[i])
        v[i] = np.random.uniform(0, 1)  # randomize the initial voltage level
```
The code above likely links back to the following formula in the book [HtBaB](Resources/How_to_Build_a_Brain.pdf) page 396
![[Pasted image 20241215183811.png]]

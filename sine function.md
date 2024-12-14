Now, use a sine as the input for the stimulus node, by defining a sine function:
```python
def sin_func(t):  
    return np.sin(2t)
```
and specifying the node as:
```python
nengo.Node(sin_func)
```
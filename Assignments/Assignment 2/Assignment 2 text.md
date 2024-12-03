---
tags:
  - Matthijs
  - Assignments
  - Marinus
---
Please note, this is taken directly out of the reader.

---
# ACT-R Subitizing Task

## 3.8.3 The Assignment

Your task is to write  a model for the subitizing task that always responds correctly by speaking the number of items on the display and also fits the human data well.

### Results from My ACT-R Model:
- **Correlation**: 0.980  
- **Mean Deviation**: 0.230  

| Items | Current Participant | Original Experiment |
|-------|----------------------|---------------------|
| 1     | 0.54 (T)            | 0.60               |
| 2     | 0.77 (T)            | 0.65               |
| 3     | 1.00 (T)            | 0.70               |
| 4     | 1.24 (T)            | 0.86               |
| 5     | 1.48 (T)            | 1.12               |
| 6     | 1.71 (T)            | 1.50               |
| 7     | 1.95 (T)            | 1.79               |
| 8     | 2.18 (T)            | 2.13               |
| 9     | 2.41 (T)            | 2.15               |
| 10    | 2.65 (T)            | 2.58               |

This model does a fair job of reproducing the range of the data. However:
- **Human data**: Small effect of set size (approx. 0.05–0.10 seconds) for 1–4 items.
- **Human data**: Larger effect (approx. 0.3 seconds) for set sizes above 4.
- **Model behavior**: Increases about 0.23 seconds for each item.

### Observations:
- The small effect for smaller displays reflects the ability to perceive small numbers of objects as familiar patterns without counting (subitizing).
- The larger effect for large displays reflects the time to retrieve counting facts.
- A more complex model could capture these effects but would require additional productions and mechanisms not covered in this tutorial.

The linear response pattern produced by this model is a sufficient approximation for the current purposes and provides a fit to the data that should be matched.

---

## Starting Model Description

A starting model for this task is in the `unit3` directory of the tutorial, named `subitize-model.lisp`. This model defines chunks encoding numbers and their ordering from 0 to 10, similar to the count and addition models from Unit 1:

```lisp
(add-dm
 (zero isa number number zero next one vocal-rep "zero")
 (one isa number number one next two vocal-rep "one")
 (two isa number number two next three vocal-rep "two")
 (three isa number number three next four vocal-rep "three")
 (four isa number number four next five vocal-rep "four")
 (five isa number number five next six vocal-rep "five")
 (six isa number number six next seven vocal-rep "six")
 (seven isa number number seven next eight vocal-rep "seven")
 (eight isa number number eight next nine vocal-rep "eight")
 (nine isa number number nine next ten vocal-rep "nine")
 (ten isa number number ten next eleven vocal-rep "ten")
 (eleven isa number number eleven)
 (goal isa count step start)
 (start))
````

- **Additional Slots**:
    - `number` and `next`: Represent the order of numbers.
    - `vocal-rep`: Holds the word string of the number (used for the model to speak it).

### Chunk-Type for Control Information:

```lisp
(chunk-type count count step)
```

- Slot `count`: Maintains the current count.
- Slot `step`: Indicates the current step.

An initial chunk `goal` with a `step` slot value of `start` is placed in the goal buffer in the starting model.

---

## Experiment Functions

### Functions:

1. **subitize-experiment** (Lisp) / **experiment** (Python):
    
    - Runs one pass through all trials in a random order.
    - No need to run multiple times as there is no randomness in timing.
2. **subitize-trial** (Lisp) / **trial** (Python):
    
    - Runs a single trial of the experiment.
    - Parameter: Number of items to display.
    - Returns response time and correctness:
        
        ```lisp
        ? (subitize-trial 3)
        (1.005 T)
        ```
        
        ```python
        >>> subitize.trial(3)
        [1.005, True]
        ```
        

### Notes:

- Model resets before each trial.
- Task starts with ACT-R trace enabled, running with a real window and in real time.
- To debug:
    - Watch the model perform the task.
    - Enable tracing.
- To speed up:
    - Disable trace and switch to a virtual window when the task is confirmed correct.

---

---
tags:
  - Matthijs
  - Assignments
  - _FirstPass
---
## Task
Your task is to write a model for the [[subitizing]] task that always responds correctly by speaking the number of items on the display and also fits the human data well
- **Deadline**: Monday November 25, 09:00h. 
---
## Notes on the assignment:
- The model also defines a chunk-type which can be used for maintaining control information in the goal buffer: (chunk-type count count step)

- ### Steps to run:
	- Load model (from tutorial/unit 3)
	- Load subitize.lisp (from turorial/lisp) - (the .python is also an option)
	- In act-r type ? (subitize-trial n) for 1 trial - with e.g. n = 3 (n is the number of x's)
	- In act-r type ? (subitize-experiment) for the entire 10 trial experiment
	- The output is going to be something like '(1.0   T)', with 'T' for true, the number is the time it took (rounded off) 

---
## Concepts:
- [[Subitizing]]
- Chunks
	- A chunk can be defined in the dm as (example). There is no need for (example isa chunk)

### code explanation



---
[[Assignment 2 text]]
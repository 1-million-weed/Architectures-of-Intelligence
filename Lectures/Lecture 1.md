---
tags:
  - Matthijs
  - Marinus
  - Lectures
---

# Course information
---
## Literature
- act r book: How can the human mind occur in the physical universe
- nengo book: How to build a brain
## Points
- 60% assignments (7)
- 40% exam

# Introduction course material
---

- **[[cognition]]: /kɒɡˈnɪʃn/**
_noun_
>the mental action or process of [acquiring](https://www.google.com/search?client=firefox-b-d&sca_esv=a8794125717d115e&sxsrf=ADLYWIIM51QlDWEPH_f9JqcCsCne262wcA:1731404895721&q=acquiring&si=ACC90nytWkp8tIhRuqKAL6XWXX-Ncjx0L6GVOrjvg0ErM5d7fsP6i5rYwJHVjXFbZDQ_qHrDUznHx594e-nGoka4A2E__v2nkWlS3VbcgI-1Q_JbvRbfmAw%3D&expnd=1&sa=X&ved=2ahUKEwi66ZXuwdaJAxX3hv0HHcrFJxYQyecJegQIQRAO) knowledge and understanding through thought, experience, and the [senses](https://www.google.com/search?client=firefox-b-d&sca_esv=a8794125717d115e&sxsrf=ADLYWIIM51QlDWEPH_f9JqcCsCne262wcA:1731404895721&q=senses&si=ACC90nwzNcbSj6HKgPz_Y9fzn5jcL3bJinFaPyjDZKtmpj5wcul4wXX_RMnwk6DY16MD0O35I3YaD-8wwu8f7buF8foyyF5H7w%3D%3D&expnd=1&sa=X&ved=2ahUKEwi66ZXuwdaJAxX3hv0HHcrFJxYQyecJegQIQRAP).

* Different types of **architecture** are useful for different purposes or functions. 
*(E.g., you wouldn't want to play a professional soccer match in a metro station)*

* Example concept 4$2 = 4+3 = 7
	* this is new information 
		* at this point we can only **recall** this information
		  (meaning: we do not know what the formula is to calculate $ )
	* when we see this again, we can start to see a **pattern**
	* when we have a pattern, we start making an **understanding**

### Specificity 
A representation of the human mind can be made on different levels of **ambiguity**. 

| ambiguity level | Program languages & other         |
| --------------- | --------------------------------- |
| high ambiguity  | ACT-r                             |
|                 | Traditional connectionists        |
|                 | Nengo & functional connectionists |
| low ambiguity   | The Human Brain Project           |

### UTC
> UTC: Unified Theory of Cognition

- A UTC should :
	- Be able to explain the total theory, not just a part
	- Be precise
	- Be end-to-end
	- Single mechanisms should explain multiple phenomena (where possible)

# ACT-r.
---
> Adaptive Control of Thought - rational

* The processes of the brain are divided into 6 groupings / areas
	* Manual control
	* Visual perception
	* Working Memory (imaginal)
	* Control goal
	* Declarative memory
	* Procedural memory
* Have a look at this [[Lecture 1 graph.canvas|Lecture 1 graph]]
* 
![[Pasted image 20241203181149.png]]
## testable predictions
All of the processes listed above are used in ACT-r to make *testable* predictions. 
Testable predictions can show that the same brain areas are active in ACT-r  as the corresponding areas in a human brain performing the same action.

We want to simulate human cognition, with a model that is cognitively plausible. 

We can test on the following metrics:
- Timing
- Learning
- Precision
- Choices
- Perception
- Active areas

## Buffers
Buffers are the connection between modules in ACT-r.

The buffers of the model are represented by **the arrows** in the aforementioned [[Lecture 1 graph.canvas|Lecture 1 graph]]

They can only carry one chunk at a time. No more.


# Memory
---
## Declarative Memory
>In declarative memory, we store facts. 
. *e.g. 4$2=7, or 'the past tense of* go *is* went'


### Chunks
> A chunk is **a single piece of information**
> *e.g. chess: Chunks represented as logical (game correct) groups. 
> Position groups (pawn wall, etc.)
> 
> A grand master at chess is able to recognise groupings of pieces, and is therefore able to store remember more pieces. If the same grandmaster looks at a board that does not resemble a possible chess configuration, they will perform just as well at remembering as everyone else.*

#### Examples of a chunk
1. all humans are mammals 
2. 465+123=588
3. \* Donald Trump will be candidate for the Democratic party
No `3` is **not** one chunk. It is made from constituent chunks (Trump, Democratic, Candidate)
>[!info] Complex ideas get multiple chunks

#### Build-up of a chunk
- name
	- e.g. Add34
- chunk type
	- e.g. ISA Addition Fact
- slots
	- e.g. 
	  addend 1   3
	  addend 2   4
	  sum           7

### Procedural Memory
> The memory of (a) sequence(s) of **skills** or **actions** is stored in procedural memory. These are often hard to articulate.
> *e.g. Like riding a bike, you can do it, but you cannot explain it.*

### Productions in ACT-R:
- If a given condition is met, follow the following procedure 
- Only one at a time
- 50 MS 'delay' per production
	- the delay is an artificial delay added to the model to have to run as fast as the human brain
	- this is justified, (not hacking) as the human brain seems to work at this speed

- The condition part of is referred to as the [[left hand side (LHS)]]
- The action part of is referred to as the [[right hand side (RHS)]]

### A production rule - example

>[!warning] If something goes wrong, look at the `trace`
>And use the `environment tools`



```lisp
(p addition
	=goal>
		ISA add-number
		number1 2 # check if slot has value '2'
		number2 =n2 # save var in slot as 
	  - multi yes # the multi slot should NOT equal yes
	    done nil # the done slot should be empty
	?retrieval> # ? used to check the state
		state free
==>
	=goal>
		multi no 
	+retrieval>
		ISA    add-fact
		addend1 2
		addend2 =n2 # should match number2 slot above
	-imaginal> # clear the imaginal buffer
)
```

>[!info] Here we do some counting
>

- Task: count 2 -5
	- Need:
		- Goal: count(2, 5)
			- **Goal Chunk**
		- declarative memory chunks
			- order of numbers (e.g. number 2 next 3)
		- productions
			- How to do something 
			- _say number, move to next, until done_


### Create declarative knowledge 
1. Define the chunk types
	- e.g. (chunk-type count first second)
	- here, we have the **chunk type** *count* with slots *first* and *second*
2. Lisp command (dm) to add to declarative memory
3. knowledge about the order of numbers
4. knowledge about the current goal
5. puts the first-goal chunk in the goal buffer

#### Production knowledge

```lisp
(p start 
	=goal>
	ISA count-from
	start = num1
	count nil
==>
	=goal>
		ISA count-from
		count=num2
	+retrieval>
	ISa count-order
	first =num1
)
```

>[!note] The above code has to complete for the below code to run

```lisp
(p increment 
	=goal>
		ISA       count-from
		count     =num1 
		end       =num1 
	+retrieval>
		ISA       count-order
		first     =num1 
		second    =num2 
==>
	=goal>
		ISA       count-from
		count     =num2 
	+retrieval>
		ISA       count-order
		first     =num2 
	!output!   (=num1) 
)
```

>[!info] Then we have this

```lisp
(p stop 
	=goal>
		ISA       count-from
		count     =num 5
	end         =num 5
==>
	=goal>
	!output!   (=num) 5
)
```

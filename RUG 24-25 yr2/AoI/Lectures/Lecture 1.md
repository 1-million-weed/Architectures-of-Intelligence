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

- **Cognition: /kɒɡˈnɪʃn/**
_noun_
>the mental action or process of [acquiring](https://www.google.com/search?client=firefox-b-d&sca_esv=a8794125717d115e&sxsrf=ADLYWIIM51QlDWEPH_f9JqcCsCne262wcA:1731404895721&q=acquiring&si=ACC90nytWkp8tIhRuqKAL6XWXX-Ncjx0L6GVOrjvg0ErM5d7fsP6i5rYwJHVjXFbZDQ_qHrDUznHx594e-nGoka4A2E__v2nkWlS3VbcgI-1Q_JbvRbfmAw%3D&expnd=1&sa=X&ved=2ahUKEwi66ZXuwdaJAxX3hv0HHcrFJxYQyecJegQIQRAO) knowledge and understanding through thought, experience, and the [senses](https://www.google.com/search?client=firefox-b-d&sca_esv=a8794125717d115e&sxsrf=ADLYWIIM51QlDWEPH_f9JqcCsCne262wcA:1731404895721&q=senses&si=ACC90nwzNcbSj6HKgPz_Y9fzn5jcL3bJinFaPyjDZKtmpj5wcul4wXX_RMnwk6DY16MD0O35I3YaD-8wwu8f7buF8foyyF5H7w%3D%3D&expnd=1&sa=X&ved=2ahUKEwi66ZXuwdaJAxX3hv0HHcrFJxYQyecJegQIQRAP).

* Different types of **architecture** are useful for different purposes or functions. 
*(E.g., you wouldn't want to play a professional soccer match in a metro station)*

* Example concept 4$2=7
	* this is new information, add this point we can only **recall** this information
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

## testable predictions
The all of the processes listed above are used in ACT-r to make testable predictions. This could for example mean that we would see the same brain areas active in ACT-r when performing addition as in a human brain performing the same action.

We can test on the following metrics:
- Timing
- Learning
- Precision
- Choices
- Perception
- Active areas

## buffers
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
> The memory of a skill or action is stored in procedural memory. These are often hard to articulate.
> *e.g. Like riding a bike, you can do it, but you cannot explain it.*

### Productions in ACT-R:
- If a given condition is met, follow the following procedure 
- Only one at a time
- 50 ms per production

### Some code

>[!warning] If something goes wrong, look at the `trace`
>And use the `environment tools`

>[!info] Hello?

```ROS
(p addition
	=goal>
		ISA
		number1
		number2
	  - multi
	    done
	?retrieval>
		state free
==>
	=goal>
		multi no 
	+retrieval>
		ISA    Some more code...
)
```

>[!info] Here we do some counting
>

- Task count 2 -5
- Knowledge type?
	- Goal: count(2, 5)
		- -> **Goal Chunk**
	- Declarative memory 
	- productions


Create declarative knowledge 
1. Define the chunks
	- chunk-type count-order first second
2. Lisp command to add somethign to declaritive memory
3. knowledge about the order of numbers
4. knowledge about the current goal
5. puts the first-goal chunk in the goal buffer

#### Production knowledge

```
(p start 
	= goal>
	ISA count-fro
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

```
(p increment 
	=goal>
		ISA       count-from
		count     =num1 2 3 4
		end       =num1 2 3 4
	+retrieval>
		ISA       count-order
		first     =num1 2 3 4
		second    =num2 3 4 5
==>
	=goal>
		ISA       count-from
		count     =num2 3 4 5
	+retrieval>
		ISA       count-order
		first     =num2 3 4 5
	!output!   (=num1) 2 3 4
)
```

>[!info] Then we have this

```
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

## List

- You dont need list. use website
- sometime usefull
- listporks

>[!note] Models are written in ACT-R
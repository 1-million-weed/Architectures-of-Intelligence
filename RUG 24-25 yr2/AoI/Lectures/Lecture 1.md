Have a look at this [[Lecture 1 graph.canvas|Lecture 1 graph]]
## Declarative Memory

### Chunks

Need to define a chunk-type

What is a chunk:
> A single piece of information
> Use chess as an example: Chunks represented as logical (game correct) groups. 
> Position groups (pawn wall, etc.)

1. all humans are mammals 
2. 465+123=588
3. Donald Trump will be candidate for the Democratic party
No `3` is not one chunk. Made from constituent chunks (Trump, Democratic, Candidate)

### Procedural Memory

Like riding a bike, you can do it but you cannot explain it.

- sequences of skills and actions 
	- Often difficult to articulate
- Productions in ACT-R:
	- Only one at a time

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
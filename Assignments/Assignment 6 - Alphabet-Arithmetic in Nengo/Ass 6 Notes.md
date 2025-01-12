---
tags:
  - Assignments
  - Marinus
Created: 2025-01-04
---
To setup your Nengo environment: [[Ass 5 Notes|Ass 5 Notes]]

> Notes and thoughts about the steps for the assignment. [[Assignment6.pdf]]

# Goal
1. Were going to create an Alphabet-Arithmetic-retrieval model and
2. **compare** it to our ACR-R model from Assignment 3 [[Commented original zbrodoff file]]

# Part 1

1. Nengo tutorials `19-22` for Semantic Pointer Architecture (spa)
2. Lecture 10 slides [[Lecture10_NeuralNets2.pdf]]
3. [[reader_AoI_2425.pdf#page=118|reader_AoI_2425, unit4]] Read pages 131-134 for refresh on the zbrodoff experiment.
4. Add a motor state and write two actions (Production rules) to make the model give the right results 

>[!def] Vocabulary 
>A vocabulary is a collection of semantic pointers with their associated vectors

Vocabularies:
- Numbers & Letters & Zbrodoff problems = 128-dimensions
- Goal states & Motor states = 16-dimensions

# GPU Functionality

So i had to wait about a `minute` for the first build to finish. Ridiculous

So I found that we can use Nengo with TensorFlow in order to utilize your GPU. 
Have a look here at the [installation guide](https://www.nengo.ai/nengo-dl/installation.html) 
And here for the [User Guide](https://www.nengo.ai/nengo-dl/user-guide.html)


# LLM Assignment Summary


## Objective
Explore an advanced Nengo model that uses semantic pointers to complete an Alphabet-Arithmetic retrieval task, and compare it to the ACT-R model developed in Assignment 3.

---

## Part 1: Model Completion

1. **Preparatory Work**:
   - Complete Nengo tutorials 19-22 to understand semantic pointer architecture (SPA) and basal ganglia.
   - Refer to lecture slides from Lecture 10.

2. **Setup**:
   - Download and unpack the provided zip file, including `zbrodoff_retrieve.py` and `.cfg` files.
   - Review the Nengo model provided, which retrieves facts to validate problems like `A + 2 = C`.

3. **Tasks**:
   - Add a motor state at line 155 using appropriate dimensionality and vocabulary (1 point).
   - Add **specific comments** to the existing basal ganglia actions, explaining their components and functionality (1.5 points).
   - Implement two new actions for "Yes" and "No" responses based on the comparison status, ensuring:
     - Proper decision-making based on `comparison_status`.
     - The model progresses to the `y_done` state.
     - No regression to earlier actions (1.5 points).

4. **Submission**:
   - Completed Python model file with detailed comments.
   - Two screenshots showing:
     - Model responding "Yes" to `B + TWO = D`.
     - Model responding "No" to `B + THREE = D`.

---

## Part 2: Reflection and Comparison

1. **Error Analysis**:
   - Analyze why the model fails with `C + ONE = D`, focusing on the relationship between semantic pointer ONE and others (1 point).

2. **Expanding the Model**:
   - Conceptualize elements required for the model to count and learn:
     - Include learning mechanisms and relevant actions as outlined in Lecture 11 (2 points).

3. **Theoretical Implications**:
   - Discuss the implications of requiring a separate "Comparison" component in Nengo versus direct comparisons in ACT-R, focusing on cognitive and neural implications (1 point).

4. **Model Comparison**:
   - Highlight theoretical advantages of:
     - Nengo model (1 point).
     - ACT-R model (1 point).

### Submission
- A PDF answering the reflection and comparison questions.

---

### Key Notes:
- The Nengo model assumes pre-learned facts and retrieves them for decision-making.
- Vocabularies are used for semantic pointers with fixed dimensionality, impacting model complexity and accuracy.
- Additional tasks and configurations include managing convolution operations, goal states, and motor responses.

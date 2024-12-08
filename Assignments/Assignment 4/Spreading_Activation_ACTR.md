---
tags:
  - Marinus
  - Assignments
  - LLM
---
# Understanding Spreading Activation in ACT-R

This section discusses **spreading activation** in declarative memory retrieval within the ACT-R cognitive architecture. Here's a breakdown:

## 1. Spreading Activation
- When trying to retrieve a chunk (unit of memory), the context provided spreads activation to related chunks in declarative memory.
- This activation depends on the **association strength** between chunks.

## 2. Activation Formula
The activation formula is:

$$A_i = B_i + \sum_k \sum_j W_{kj} S_{ji} + \epsilon$$

Where:
- \( A_i \): Total activation of chunk \(i\).
- \( B_i \): Base-level activation (depends on frequency and recency of usage).
- \( W_{kj} \): Weight of activation from source \(j\) in buffer \(k\).
- \( S_{ji} \): Strength of association from source \(j\) to chunk \(i\).
- \( \epsilon \): Noise (random variation in activation).

## 3. Key Terms
### Sources of Activation
- Slots in buffers holding chunks related to the target chunk.

### Weights ($W_{kj}$)
- Distributed activation across slots in buffers, summing to \(W_k\), the total activation per buffer.

### Strengths of Association ($S_{ji}$)
- If chunks \(j\) and \(i\) are unrelated, \(S_{ji} = 0\).
- Otherwise, \( S_{ji} = S - \ln(\text{fan}_j) \), where:
  - \(S\): Maximum associative strength.
  - \(\text{fan}_j\): Number of chunks associated with \(j\), accounting for competition.

## 4. Default Case
- In ACT-R, only the **imaginal buffer** contributes activation by default.
- Its weight (\(W_{\text{imaginal}}\)) is 1, while other buffers default to 0.
- Simplified formula:

$$A_i = B_i + \sum_j \frac{1}{n} S_{ji} + \epsilon$$

Where:
- \(n\): Number of chunks in the imaginal buffer slots.

## 5. Diagram Explanation
The diagram likely illustrates:
- An **imaginal chunk** with multiple slots.
- The spreading of activation to declarative memory chunks based on slot contents and their associations.

Let me know if you'd like further clarification!

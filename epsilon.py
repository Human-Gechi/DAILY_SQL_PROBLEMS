import numpy as np
epsilon = np.finfo(np.float32).eps
gamma = 1/(epsilon * 2.0)
print(f"Machine epsilon for single precision is {epsilon}")
print(f"Gamma for single precision is {gamma}")
epsilond = np.finfo(np.float64).eps
print(f"Machine epsilon for double precision is {epsilond}")
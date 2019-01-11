import numpy as np
from scipy.linalg import expm3,expm, norm
import libexpmf
import time
from math import factorial

def my_expm(a,num_terms):
    ret_mat =np.copy(a,order='F')
    libexpmf.expm(a,ret_mat,num_terms)
    return ret_mat

def myPy_expm(A,n):
    prev_mat = np.identity(A.shape[0])
    total_sum = prev_mat
    for i in range(1,n):
        temp = np.matmul(prev_mat,A)
        total_sum = total_sum + (temp)/factorial(i)
        prev_mat = temp
    return total_sum

# Test matrix
T=np.random.randn(4,4)+np.random.randn(4,4)*1j

print(norm(expm3(T,15)))
print(norm(my_expm(T,15)))
print(norm(myPy_expm(T,15)))

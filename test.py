import numpy as np


# expm3 is deprecated and less accurate than expm

# expm3 uses the taylor expansion, while expm uses the pade approximation
# Taylor expansion is fine for matrices with small values.

from scipy.linalg import expm3,expm, norm
import libexpmf
import time
from math import factorial

# Fortran function is generated through
# f2py3 -c expmf.f95 -m libexpmf




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






#number of terms in taylor expansion
N=15


# Matrix dimension
n = 4

# 18
max_pot = 15
print("{:<25} {:<25} {:<25} {:<25}".format("Fortran_duration", "Python_Duration", "Ratio", "Num_matrices"))
print("-"*105)
for pot in range(0,max_pot+1):
    a = [np.random.randn(n,n)+np.random.randn(n,n)*1j for i in range(0,2**pot) ]

    stf=time.time()
    c_fortran=[my_expm(a[i],N) for i in range(0,len(a))]
    etf=time.time()

    stp=time.time()
    c_python=[expm3(a[i],N) for i in range(0,len(a))]
    etp=time.time()

    python_duration= etp-stp
    fortran_duration= etf-stf

    print("{:<25} {:<25} {:<25} {:<25}".format(fortran_duration,python_duration,round(python_duration/fortran_duration,4),2**pot))


N_checks = 1000


magnitudes =[0.01,0.1,1,10]

for m in magnitudes:
    print("\nMatrix is scaled by {}".format(m))
    acc_3 =0.0
    acc_my=0.0
    acc_myPy =0.0
    for i in range(0,N_checks):
        check = m*(np.random.randn(n,n)+np.random.randn(n,n)*1j)
        norm_expm3 = norm(expm3(check,N))
        norm_my_expm  = norm(my_expm(check,N))
        norm_expm =norm(expm(check))
        norm_myPy_expm = norm(myPy_expm(check,N))
        acc_3 += np.abs(norm_expm-norm_expm3)/norm_expm
        acc_my += np.abs(norm_expm-norm_my_expm)/norm_expm
        acc_myPy += np.abs(norm_expm-norm_myPy_expm)/norm_expm

    print("Average error to expm (This is using the more stable pade approximation) with {} samples".format(N_checks))
    print(" expm3   :  ",acc_3/N_checks )
    print(" my_expm :  ",acc_my/N_checks)
    print(" myPy_expm :  ",acc_myPy/N_checks)


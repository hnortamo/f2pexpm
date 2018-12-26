import numpy as np
from scipy.linalg import expm3
import libexpmf
import time

# Fortran function is generated through
# f2py3 -c expmf.f95 -m libexpmf


def my_expm(a,num_terms):
    ret_mat =np.copy(a,order='F')
    libexpmf.expm(a,ret_mat,num_terms)
    return ret_mat



#number of terms in taylor expansion
N=15
# 18
max_pot = 9


for pot in range(0,max_pot+1):
    a = [np.random.randn(4,4)+0.11j for i in range(0,2**pot) ]

    stf=time.time()
    c_fortran=[my_expm(a[i],N) for i in range(0,len(a))]
    etf=time.time()

    stp=time.time()
    c_python=[expm3(a[i],N) for i in range(0,len(a))]
    etp=time.time()

    python_duration= etp-stp
    fortran_duration= etf-stf

    print(fortran_duration,python_duration,round(python_duration/fortran_duration,4),2**pot)


check = np.random.randn(4,4)+0.11j
print(expm3(check,N))
print(my_expm(check,N))


print("Done")

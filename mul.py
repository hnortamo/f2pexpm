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



res = np.asfortranarray(np.zeros((4,4))+0j)
a = np.random.randn(4,4)+1j
#number of terms in taylor expansion
N=15
# 18
max_pot = 9


for pot in range(0,max_pot+1):

    start_time_f=time.time()
    for i in range(0,2**pot):
        c=my_expm(a,N)
        #libexpmf.expm(a,res,N)
    end_time_f=time.time()
   # print(res)

    start_time_py=time.time()
    for i in range(0,2**pot):
        c=expm3(a,N)
    end_time_py=time.time()
    #print(expm3(a,N))
    print(end_time_f-start_time_f,end_time_py-start_time_py,2**pot)

print(expm3(a,N))
print(my_expm(a,N))


print("Done")

# MWE for custom expm function



import numpy as np
# The libexpmf is generated with the build.sh in this directory
import libexpmf



# Use in the same way as pythons own expm or expm3

def my_expm(a,num_terms=20):
    ret_mat =np.zeros(np.shape(a),dtype=complex,order='F')
    libexpmf.expm(a,ret_mat,num_terms)
    return ret_mat

a = np.random.randn(16,16)+np.random.randn(16,16)*1j
for i in range(0,100000):
    my_expm(a)
print("Done")

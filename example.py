# MWE for custom expm function



import numpy as np
# The libexpmf is generated with the build.sh in this directory
import libexpmf



# Use in the same way as pythons own expm or expm3
def my_expm(a,num_terms=15):
    ret_mat =np.copy(a,order='F')
    libexpmf.expm(a,ret_mat,num_terms)
    return ret_mat

a = np.random.randn(4,4)+np.random.randn(4,4)*1j
my_expm(a)
print("Done")

pgf90 -c -fPIC cuda_mul.cuf
pgf90 -o libcuexp.so cuda_mul.o -shared
pgf90 pyfort.f95 -L . -lcuexp  -L /appl/opt/pgi/17.9/linux86-64/17.9/lib/ -lcudafor -L /appl/opt/cuda/10.0/lib64/ -lcusparse -lcudart -lcudaforblas

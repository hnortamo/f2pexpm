
# module load cuda/10
# module load pgi/17.10
cp -f cuda_mul.f95 cuda_mul.cuf
pgf90 cuda_mul.cuf main.f95 -o main
# srun -p gpu --gres=gpu:p100:1 -t 0:05:00 --mem 5G --cpus-per-task 1 -n 1 time ./main
#pgf90 -c -fPIC cuda_mul.cuf
#pgf90 -o libcuexp.so cuda_mul.o -shared
#pgf90 -o main main.f95 -L . -lcuexp  -L /appl/opt/pgi/17.9/linux86-64/17.9/lib/ -lcudafor -L /appl/opt/cuda/10.0/lib64/ -lcusparse -lcudart -lcudaforblas

CC=nvcc
LIBS= -lpthread
#-rdc=true = If disabled, executable device code is generated. Relocatable device code must be linked before it can be executed. 
CUDA_FLAGS= -Xptxas -O3 -rdc=true -arch=sm_86 # -Xptxas -O3 is used for ptx level cuda optimixation. Default optimization level is O3.
CPP_FLAGS= -std=c++17 -O3 # the level of CPP optimization is O3 here.
all: cuda_code.o c_plus_plus_code.o
	$(CC) -o a.out cuda_code.o c_plus_plus_code.o $(CUDA_FLAGS) $(CPP_FLAGS) $(LIBS)

cuda_code.o: cuda_code.cu
	$(CC) $(CPP_FLAGS) $(CUDA_FLAGS) $(LIBS) -c cuda_code.cu

c_plus_plus_code: c_plus_plus_code.cpp
	$(CC) $(CPP_FLAGS) $(CUDA_FLAGS) $(LIBS) -c c_plus_plus_code.cpp

clean:
	rm -rf *o a.out
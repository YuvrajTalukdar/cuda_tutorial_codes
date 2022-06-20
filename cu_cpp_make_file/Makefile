CC=nvcc
LIBS= -lpthread
#If disabled, executable device code is generated. Relocatable device code must be linked before it can be executed. 
CUDA_FLAGS= -rdc=true -arch=sm_86 -Xptxas # -Xptxas is used for cuda optimixation
CPP_FLAGS= -O2 -std=c++17 # the level of cuda optimization is O2 here. O2 needs to be just after Xptas flag thats why used first here.
all: cuda_code.o c_plus_plus_code.o
	$(CC) -o a.out cuda_code.o c_plus_plus_code.o $(CUDA_FLAGS) $(CPP_FLAGS) $(LIBS)

cuda_code.o: cuda_code.cu
	$(CC) $(CUDA_FLAGS) $(CPP_FLAGS) $(LIBS) -c cuda_code.cu

c_plus_plus_code: c_plus_plus_code.cpp
	$(CC) $(CUDA_FLAGS) $(CPP_FLAGS) $(LIBS) -c c_plus_plus_code.cpp

clean:
	rm -rf *o a.out
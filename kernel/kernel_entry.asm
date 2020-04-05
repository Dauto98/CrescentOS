; Ensures that we jump straight into the kernel;s entry function
[bits 32]
[extern main] ; like extern in C, the linker will find the main fuction when linking

call main ; invoke the main() function in C kernel
jmp $ ; hang there forever, but we shouldn't get to this part anyway
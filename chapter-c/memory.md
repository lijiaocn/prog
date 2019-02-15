# 内存管理操作
<!-- toc -->

## 从栈上分配会自动回收的内存

`man alloca`

```c
#include <alloca.h>

void *alloca(size_t size);
```

这个函数需要特意说明一下，alloca分配的是调用它的函数的栈中的内存，在调用函数返回时，alloca分配的内存会随着栈空间的释放一同释放。

<!-- toc -->
# 动态链接库操作

## 打开/关闭动态链接库

```c
#include <dlfcn.h>

void *dlopen(const char *filename, int flag);

char *dlerror(void);

void *dlsym(void *handle, const char *symbol);

int dlclose(void *handle);
```

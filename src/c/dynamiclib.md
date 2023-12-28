<!-- toc -->
# 动态链接库操作

## 打开/关闭动态链接库

```c
#include <dlfcn.h>

void *dlopen(const char *filename, int flag);

int dlclose(void *handle);
```

## 读取动态链接库的操作错误

```c
#include <dlfcn.h>

char *dlerror(void);
```

## 获取动态链接库中的符号地址

```c
#include <dlfcn.h>

void *dlsym(void *handle, const char *symbol);
```

例如：

```c
static int do_proc_open(const char *path, struct fuse_file_info *fi)
{
    int (*proc_open)(const char *path, struct fuse_file_info *fi);
    char *error;
    dlerror();    /* Clear any existing error */
    proc_open = (int (*)(const char *path, struct fuse_file_info *fi)) dlsym(dlopen_handle, "proc_open");
    error = dlerror();
    if (error != NULL) {
        lxcfs_error("%s\n", error);
        return -1;
    }

    return proc_open(path, fi);
}
```

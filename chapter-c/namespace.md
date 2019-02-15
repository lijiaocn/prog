# Namespace相关操作
<!-- toc -->

## 当前进程关联到指定的namespace

```c
#define _GNU_SOURCE             /* See feature_test_macros(7) */
#include <sched.h>

int setns(int fd, int nstype);
```

fd是`/proc/进程号/ns/`中的某个文件打开后的句柄，nstype可以取以下值：

```
0      Allow any type of namespace to be joined.

CLONE_NEWIPC
       fd must refer to an IPC namespace.

CLONE_NEWNET
       fd must refer to a network namespace.

CLONE_NEWUTS
       fd must refer to a UTS namespace.
```

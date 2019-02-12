<!-- toc -->
# 进程管理操作

## 获取进程ID

`man pid`

```c
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void);
pid_t getppid(void);
```

分别是获取当前进程id，和父进程id。

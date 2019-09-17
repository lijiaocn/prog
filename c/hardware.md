<!-- toc -->
# 硬件信息读取

## 读取CPU个数

读取系统配置的cpu个数和可用的cpu个数和，`man get_nprocs`：

```c
#include <sys/sysinfo.h>

int get_nprocs_conf(void);
int get_nprocs(void);
```

`get_nprocs_conf()`返回的配置的CPU个数可能会大于`get_nprocs()`返回的可用的CPU个数，因为CPU可能离线（offline）不可用。

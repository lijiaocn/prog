# 进程管理操作
<!-- toc -->

## 获取进程ID

`man pid`

```c
#include <sys/types.h>
#include <unistd.h>

pid_t getpid(void);
pid_t getppid(void);
```

分别是获取当前进程id，和父进程id。

## 创建子进程

### fork

`man fork`

```c
#include <unistd.h>

pid_t fork(void);
```

子进程创建失败返回`-1`，创建成功，在父进程中返回子进程的`进程号`，在子进程中返回`0`。

### clone

`man clone`

`clone()`比`fork()`功能更强大，可以传入子进程的运行函数，以及设置namespace等。

```c
#include <sched.h>

int clone(int (*fn)(void *), void *child_stack,
          int flags, void *arg, ...
          /* pid_t *ptid, struct user_desc *tls, pid_t *ctid */ );

/* Prototype for the raw system call */

long clone(unsigned long flags, void *child_stack,
          void *ptid, void *ctid,
          struct pt_regs *regs);
```

上面第一个定义是glibc提供的，封装了原始的clone系统调用，第二个定义是原始的clone系统调用定义。

关键是参数`flags`，它的bit位有特殊含义，分别是退出时向父进程发送的信号量和下面的标志位（具体说明查阅手册`man clone`）：

```
CLONE_CHILD_CLEARTID (since Linux 2.5.49)
CLONE_CHILD_SETTID (since Linux 2.5.49)
CLONE_FILES (since Linux 2.0)
CLONE_FS (since Linux 2.0)
CLONE_IO (since Linux 2.6.25)
CLONE_NEWIPC (since Linux 2.6.19)
CLONE_NEWNET (since Linux 2.6.24)
CLONE_NEWNS (since Linux 2.4.19)
CLONE_NEWPID (since Linux 2.6.24)
CLONE_NEWUTS (since Linux 2.6.19)
CLONE_PARENT (since Linux 2.3.12)
CLONE_PARENT_SETTID (since Linux 2.5.49)
CLONE_PID (obsolete)
CLONE_PTRACE (since Linux 2.2)
CLONE_SETTLS (since Linux 2.5.32)
CLONE_SIGHAND (since Linux 2.0)
CLONE_STOPPED (since Linux 2.6.0-test2)
CLONE_SYSVSEM (since Linux 2.5.10)
CLONE_THREAD (since Linux 2.4.0-test8)
CLONE_UNTRACED (since Linux 2.5.46)
CLONE_VFORK (since Linux 2.2)
CLONE_VM (since Linux 2.0)
```

例如子进程退出时向父进程发送SIGCHLD信号：

```c
pid = clone(childFunc, stackTop, CLONE_NEWUTS | SIGCHLD, argv[1]);
if (pid == -1)
    errExit("clone");
printf("clone() returned %ld\n", (long) pid);
```




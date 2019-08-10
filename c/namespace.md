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

## 解除namespace关联

[new system call, unshare](https://lwn.net/Articles/135266/)，`man unshare`。

```c
#include <sched.h>

int unshare(int flags);
```

unshare() allows a process to disassociate parts of its execution context that are currently being shared with other processes.  Part of the execution context, such as the mount namespace, is
shared implicitly when a new process is created using fork(2) or vfork(2), while other parts, such as virtual memory, may be shared by explicit request when creating a process using clone(2).

参数flags可以使用一下标志位：

```
CLONE_FILES
       Reverse the effect of the clone(2) CLONE_FILES flag.  Unshare the  file  descriptor  table,  so
       that the calling process no longer shares its file descriptors with any other process.

CLONE_FS
       Reverse  the effect of the clone(2) CLONE_FS flag.  Unshare file system attributes, so that the
       calling process no longer shares its root directory (chroot(2)), current directory  (chdir(2)),
       or umask (umask(2)) attributes with any other process.

CLONE_NEWIPC (since Linux 2.6.19)
       This  flag  has  the  same  effect as the clone(2) CLONE_NEWIPC flag.  Unshare the System V IPC
       namespace, so that the calling process has a private copy of the System V IPC  namespace  which
       is not shared with any other process.  Specifying this flag automatically implies CLONE_SYSVSEM
       as well.  Use of CLONE_NEWIPC requires the CAP_SYS_ADMIN capability.

CLONE_NEWNET (since Linux 2.6.24)
       This flag has the same effect as the clone(2) CLONE_NEWNET flag.  Unshare  the  network  names‐
       pace,  so  that  the  calling process is moved into a new network namespace which is not shared
       with any previously existing process.  Use of CLONE_NEWNET requires the CAP_SYS_ADMIN  capabil‐
       ity.

CLONE_NEWNS
       This  flag  has the same effect as the clone(2) CLONE_NEWNS flag.  Unshare the mount namespace,
       so that the calling process has a private copy of its namespace which is not  shared  with  any
       other  process.   Specifying  this  flag  automatically  implies  CLONE_FS  as  well.   Use  of
       CLONE_NEWNS requires the CAP_SYS_ADMIN capability.

CLONE_NEWUTS (since Linux 2.6.19)
       This flag has the same effect as the clone(2) CLONE_NEWUTS flag.  Unshare the  UTS  IPC  names‐
       pace,  so  that the calling process has a private copy of the UTS namespace which is not shared
       with any other process.  Use of CLONE_NEWUTS requires the CAP_SYS_ADMIN capability.

CLONE_SYSVSEM (since Linux 2.6.26)
       This flag reverses the effect of the clone(2) CLONE_SYSVSEM flag.  Unshare System  V  semaphore
       undo  values, so that the calling process has a private copy which is not shared with any other
       process.  Use of CLONE_SYSVSEM requires the CAP_SYS_ADMIN capability.
```

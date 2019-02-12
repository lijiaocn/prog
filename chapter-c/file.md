<!-- toc -->
# 文件&设备操作

## 打开、创建文件

`man open`

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);

int creat(const char *pathname, mode_t mode);
```

## 关闭文件

`man close`

```c
#include <unistd.h>

int close(int fildes);
```

## 文件描述符

`man fcntl`

```c
#include <unistd.h>
#include <fcntl.h>

int fcntl(int fd, int cmd, ... /* arg */ );
```

对已经打开的文件描述符进行操作。可以进行的操作比较多，而且用途三言两语难以说清楚，这里只列出个目录，详情到man手册中查看。

文件描述符复制（Duplicating a file descriptor）：

	 F_DUPFD (int)、F_DUPFD_CLOEXEC (int; since Linux 2.6.24)

文件描述符标记（File descriptor flags）：

	 F_GETFD (void)、F_SETFD (int)

文件状态标记（File status flags）：

	F_GETFL (void)、F_SETFL (int)

文件软锁（Advisory locking）：

	F_SETLK (struct flock *)、F_SETLKW (struct flock *)、F_GETLK (struct flock *)

文件信号响应管理（Managing signals）：

	F_GETOWN (void)、F_SETOWN (int)、F_GETOWN_EX (struct f_owner_ex *) (since Linux 2.6.32)
	F_SETOWN_EX (struct f_owner_ex *) (since Linux 2.6.32)、F_GETSIG (void)、F_SETSIG (int)

文件描述符租约（Leases）：

	 F_SETLEASE (int)、 F_GETLEASE (void)

文件和路径变化通知（File and directory change notification (dnotify)）：

	 F_NOTIFY (int)

Pipe容量设置（Changing the capacity of a pipe）：

	F_SETPIPE_SZ (int; since Linux 2.6.35)、F_GETPIPE_SZ (void; since Linux 2.6.35)

## 将文件内容截断到指定长度

`man truncate`

```c
#include <unistd.h>
#include <sys/types.h>

int truncate(const char *path, off_t length);
int ftruncate(int fd, off_t length);
```

## 向文件中写入内容

`man 3 write`

```c
#include <unistd.h>

ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
       off_t offset);
ssize_t write(int fildes, const void *buf, size_t nbyte);
```

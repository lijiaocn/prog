# 文件&设备操作
<!-- toc -->

## 获取文件状态

`man 2 stat`

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

int stat(const char *path, struct stat *buf);
int fstat(int fd, struct stat *buf);
int lstat(const char *path, struct stat *buf);
```

`struct stat`在`/usr/include/bits/stat.h`中定义，原始定义中使用很多宏不方便阅读，可以用以下定义代替：

```c
struct stat {
    dev_t     st_dev;     /* ID of device containing file */
    ino_t     st_ino;     /* inode number */
    mode_t    st_mode;    /* protection */
    nlink_t   st_nlink;   /* number of hard links */
    uid_t     st_uid;     /* user ID of owner */
    gid_t     st_gid;     /* group ID of owner */
    dev_t     st_rdev;    /* device ID (if special file) */
    off_t     st_size;    /* total size, in bytes */
    blksize_t st_blksize; /* blocksize for file system I/O */
    blkcnt_t  st_blocks;  /* number of 512B blocks allocated */
    time_t    st_atime;   /* time of last access */
    time_t    st_mtime;   /* time of last modification */
    time_t    st_ctime;   /* time of last status change */
};
```

可以用下面的宏定义判断文件类型，传入参数是stat中的`st_mode`：

```c
S_ISREG(m)  is it a regular file?
S_ISDIR(m)  directory?
S_ISCHR(m)  character device?
S_ISBLK(m)  block device?
S_ISFIFO(m) FIFO (named pipe)?
S_ISLNK(m)  symbolic link?  (Not in POSIX.1-1996.)
S_ISSOCK(m) socket?  (Not in POSIX.1-1996.)
```

st_mode中每个bit含义如下：

```c
S_IFMT     0170000   bit mask for the file type bit fields
S_IFSOCK   0140000   socket
S_IFLNK    0120000   symbolic link
S_IFREG    0100000   regular file
S_IFBLK    0060000   block device
S_IFDIR    0040000   directory
S_IFCHR    0020000   character device
S_IFIFO    0010000   FIFO
S_ISUID    0004000   set-user-ID bit
S_ISGID    0002000   set-group-ID bit (see below)
S_ISVTX    0001000   sticky bit (see below)
S_IRWXU    00700     mask for file owner permissions
S_IRUSR    00400     owner has read permission
S_IWUSR    00200     owner has write permission
S_IXUSR    00100     owner has execute permission
S_IRWXG    00070     mask for group permissions
S_IRGRP    00040     group has read permission
S_IWGRP    00020     group has write permission
S_IXGRP    00010     group has execute permission
S_IRWXO    00007     mask for permissions for others (not in group)
S_IROTH    00004     others have read permission
S_IWOTH    00002     others have write permission
S_IXOTH    00001     others have execute permission
```

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

`openat()`是相对指定的目录描述符打开文件：

```c
#include <fcntl.h>

int openat(int dirfd, const char *pathname, int flags);
int openat(int dirfd, const char *pathname, int flags, mode_t mode);
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

## 文件内容截断到指定长度

`man truncate`

```c
#include <unistd.h>
#include <sys/types.h>

int truncate(const char *path, off_t length);
int ftruncate(int fd, off_t length);
```

## 逐行读取文件内容

```c
#include <stdio.h>

ssize_t getline(char **lineptr, size_t *n, FILE *stream);

ssize_t getdelim(char **lineptr, size_t *n, int delim, FILE *stream);
```

`*lineptr`是存放一行文本的内存地址，`*n`是`*lineptr`指向的内存空间的大小。

**注意**：如果`*lineptr`是null，getline和getdelim会让`*lineptr`指定自动分配的一块内存，要主动释放`*lineptr`指向的内存，这种情况下`*n`被忽略。

**注意**：如果`*lineptr`指定的内存空间不足以存放整行数据，getline和getdelim会调用realloc重新分配内存，更改`*lineptr`指向新分配的内存，并同步更新`*n`。 

## 向文件中写入内容

`man 3 write`

```c
#include <unistd.h>

ssize_t pwrite(int fildes, const void *buf, size_t nbyte,
       off_t offset);
ssize_t write(int fildes, const void *buf, size_t nbyte);
```

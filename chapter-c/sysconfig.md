# 系统配置读取
<!-- toc -->

## 操作系统相关配置获取

sysconf：   获取数值类型的配置项

fpathconf： 获取打开的文件句柄对应的配置项

pathconf：  获取文件对应的配置项

confstr：   获取字符串类型的配置项

```c
#include <unistd.h>

long sysconf(int name);
long fpathconf(int fd, int name);
long pathconf(char *path, int name);
size_t confstr(int name, char *buf, size_t len);
```

### sysconf

sysconf用于在运行时获取系统配置常量，主要是POSIX中规定一些参数，例如最大长度、最大数值等。

`man 3 sysconf`

```c
#include <unistd.h>

long sysconf(int name);
```

`sysconf`可以读取以下配置：

First, the POSIX.1 compatible values.

```
ARG_MAX - _SC_ARG_MAX
    The maximum length of the arguments to the exec(3) family of functions.  Must not be less than _POSIX_ARG_MAX (4096).

CHILD_MAX - _SC_CHILD_MAX
    The maximum number of simultaneous processes per user ID.  Must not be less than _POSIX_CHILD_MAX (25).

HOST_NAME_MAX - _SC_HOST_NAME_MAX
    Maximum length of a hostname, not including the terminating null byte, as returned by gethostname(2).  Must not be less than _POSIX_HOST_NAME_MAX (255).

LOGIN_NAME_MAX - _SC_LOGIN_NAME_MAX
    Maximum length of a login name, including the terminating null byte.  Must not be less than _POSIX_LOGIN_NAME_MAX (9).

clock ticks - _SC_CLK_TCK
    The  number  of  clock  ticks per second.  The corresponding variable is obsolete.  It was of course called CLK_TCK.  (Note: the macro CLOCKS_PER_SEC does not give information: it must
    equal 1000000.)

OPEN_MAX - _SC_OPEN_MAX
    The maximum number of files that a process can have open at any time.  Must not be less than _POSIX_OPEN_MAX (20).

PAGESIZE - _SC_PAGESIZE
    Size of a page in bytes.  Must not be less than 1.  (Some systems use PAGE_SIZE instead.)

RE_DUP_MAX - _SC_RE_DUP_MAX
    The number of repeated occurrences of a BRE permitted by regexec(3) and regcomp(3).  Must not be less than _POSIX2_RE_DUP_MAX (255).

STREAM_MAX - _SC_STREAM_MAX
    The maximum number of streams that a process can have open at any time.  If defined, it has the same value as the standard C macro FOPEN_MAX.  Must not be less  than  _POSIX_STREAM_MAX
    (8).

SYMLOOP_MAX - _SC_SYMLOOP_MAX
    The maximum number of symbolic links seen in a pathname before resolution returns ELOOP.  Must not be less than _POSIX_SYMLOOP_MAX (8).

TTY_NAME_MAX - _SC_TTY_NAME_MAX
    The maximum length of terminal device name, including the terminating null byte.  Must not be less than _POSIX_TTY_NAME_MAX (9).

TZNAME_MAX - _SC_TZNAME_MAX
    The maximum number of bytes in a timezone name.  Must not be less than _POSIX_TZNAME_MAX (6).

_POSIX_VERSION - _SC_VERSION
    indicates the year and month the POSIX.1 standard was approved in the format YYYYMML; the value 199009L indicates the Sept. 1990 revision.
```

Next, the POSIX.2 values, giving limits for utilities.

```
BC_BASE_MAX - _SC_BC_BASE_MAX
    indicates the maximum obase value accepted by the bc(1) utility.

BC_DIM_MAX - _SC_BC_DIM_MAX
    indicates the maximum value of elements permitted in an array by bc(1).

BC_SCALE_MAX - _SC_BC_SCALE_MAX
    indicates the maximum scale value allowed by bc(1).

BC_STRING_MAX - _SC_BC_STRING_MAX
    indicates the maximum length of a string accepted by bc(1).

COLL_WEIGHTS_MAX - _SC_COLL_WEIGHTS_MAX
    indicates the maximum numbers of weights that can be assigned to an entry of the LC_COLLATE order keyword in the locale definition file,

EXPR_NEST_MAX - _SC_EXPR_NEST_MAX
    is the maximum number of expressions which can be nested within parentheses by expr(1).

LINE_MAX - _SC_LINE_MAX
    The maximum length of a utility's input line, either from standard input or from a file.  This includes space for a trailing newline.

RE_DUP_MAX - _SC_RE_DUP_MAX
    The maximum number of repeated occurrences of a regular expression when the interval notation \{m,n\} is used.

POSIX2_VERSION - _SC_2_VERSION
    indicates the version of the POSIX.2 standard in the format of YYYYMML.

POSIX2_C_DEV - _SC_2_C_DEV
    indicates whether the POSIX.2 C language development facilities are supported.

POSIX2_FORT_DEV - _SC_2_FORT_DEV
    indicates whether the POSIX.2 FORTRAN development utilities are supported.

POSIX2_FORT_RUN - _SC_2_FORT_RUN
    indicates whether the POSIX.2 FORTRAN run-time utilities are supported.

_POSIX2_LOCALEDEF - _SC_2_LOCALEDEF
    indicates whether the POSIX.2 creation of locates via localedef(1) is supported.

POSIX2_SW_DEV - _SC_2_SW_DEV
    indicates whether the POSIX.2 software development utilities option is supported.
```

These values also exist, but may not be standard.

```
 - _SC_PHYS_PAGES
    The number of pages of physical memory.  Note that it is possible for the product of this value and the value of _SC_PAGESIZE to overflow.

 - _SC_AVPHYS_PAGES
    The number of currently available pages of physical memory.

 - _SC_NPROCESSORS_CONF
    The number of processors configured.

     - _SC_NPROCESSORS_ONLN
           The number of processors currently online (available).
```

### pathconf 和 fpathconf

`man  pathconf`

```c
#include <unistd.h>

long fpathconf(int fd, int name);
long pathconf(char *path, int name);
```

Setting name equal to one of the following constants returns the following configuration options:

```
_PC_LINK_MAX
    returns the maximum number of links to the file.  If fd or path refer to a directory, then the value applies to the whole directory.  The corresponding macro is _POSIX_LINK_MAX.

_PC_MAX_CANON
    returns the maximum length of a formatted input line, where fd or path must refer to a terminal.  The corresponding macro is _POSIX_MAX_CANON.

_PC_MAX_INPUT
    returns the maximum length of an input line, where fd or path must refer to a terminal.  The corresponding macro is _POSIX_MAX_INPUT.

_PC_NAME_MAX
    returns the maximum length of a filename in the directory path or fd that the process is allowed to create.  The corresponding macro is _POSIX_NAME_MAX.

_PC_PATH_MAX
    returns the maximum length of a relative pathname when path or fd is the current working directory.  The corresponding macro is _POSIX_PATH_MAX.

_PC_PIPE_BUF
    returns the size of the pipe buffer, where fd must refer to a pipe or FIFO and path must refer to a FIFO.  The corresponding macro is _POSIX_PIPE_BUF.

_PC_CHOWN_RESTRICTED
    returns nonzero if the chown(2) call may not be used on this file.  If fd or path refer to a directory, then this applies to all files in that directory.  The  corresponding  macro  is
    _POSIX_CHOWN_RESTRICTED.

_PC_NO_TRUNC
    returns nonzero if accessing filenames longer than _POSIX_NAME_MAX generates an error.  The corresponding macro is _POSIX_NO_TRUNC.

_PC_VDISABLE
    returns nonzero if special character processing can be disabled, where fd or path must refer to a terminal.
```

### confstr

The name argument is the system variable to be queried.  The following variables are supported:

```
_CS_GNU_LIBC_VERSION (GNU C library only; since glibc 2.3.2)
    A string which identifies the GNU C library version on this system (e.g, "glibc 2.3.4").

_CS_GNU_LIBPTHREAD_VERSION (GNU C library only; since glibc 2.3.2)
    A string which identifies the POSIX implementation supplied by this C library (e.g, "NPTL 2.3.4" or "linuxthreads-0.10").

_CS_PATH
    A value for the PATH variable which indicates where all the POSIX.2 standard utilities can be found.
```

<!-- toc -->
# C语言中的时间操作

## 获取当前时间

获取`相对指定时钟`的当前时间：

`man clock_gettime`

```c
#include <time.h>

int clock_getres(clockid_t clk_id, struct timespec *res);

int clock_gettime(clockid_t clk_id, struct timespec *tp);

int clock_settime(clockid_t clk_id, const struct timespec *tp);

Link with -lrt (only for glibc versions before 2.17).
```

`*res`是返回的当前时间，定义如下：

```c
struct timespec {
    time_t   tv_sec;        /* seconds */
    long     tv_nsec;       /* nanoseconds */
};
```

时钟`clk_id`可以取以下值：

CLOCK_REALTIME：

       System-wide  clock  that  measures  real  (i.e., wall-clock) time.  Setting this clock requires
       appropriate privileges.  This clock is affected by  discontinuous  jumps  in  the  system  time
       (e.g.,  if the system administrator manually changes the clock), and by the incremental adjust‐
       ments performed by adjtime(3) and NTP.

CLOCK_REALTIME_COARSE (since Linux 2.6.32; Linux-specific)：

       A faster but less precise version of CLOCK_REALTIME.  Use when you  need  very  fast,  but  not
       fine-grained timestamps.

CLOCK_MONOTONIC：

       Clock  that  cannot be set and represents monotonic time since some unspecified starting
       point.  This clock is not affected by discontinuous jumps in the system time  (e.g.,  if
       the system administrator manually changes the clock), but is affected by the incremental
       adjustments performed by adjtime(3) and NTP.

CLOCK_MONOTONIC_COARSE (since Linux 2.6.32; Linux-specific)：

       A faster but less precise version of CLOCK_MONOTONIC.  Use when you need very fast,  but
       not fine-grained timestamps.

CLOCK_MONOTONIC_RAW (since Linux 2.6.28; Linux-specific)：

       Similar to CLOCK_MONOTONIC, but provides access to a raw hardware-based time that is not
       subject to NTP adjustments or the incremental adjustments performed by adjtime(3).

CLOCK_BOOTTIME (since Linux 2.6.39; Linux-specific)：

       Identical to CLOCK_MONOTONIC, except it also includes any time that the system  is  sus‐
       pended.   This allows applications to get a suspend-aware monotonic clock without having
       to deal with the complications of CLOCK_REALTIME, which may have discontinuities if  the
       time is changed using settimeofday(2).

CLOCK_PROCESS_CPUTIME_ID：

       High-resolution per-process timer from the CPU.

CLOCK_THREAD_CPUTIME_ID：

       Thread-specific CPU-time clock.

其中`CLOCK_BOOTTIME`可以简单理解为系统启动以后过去的时间，[Introduce CLOCK_BOOTTIME ](https://lwn.net/Articles/420142/)。

## 获取指定进程的启动时间和运行时长

[lxcfs](https://github.com/lxc/lxcfs)中的做法，适用于linux。

`/proc/[PID]/stat`文件的第22个字段是进程创建时间，单位是系统时钟嘀嗒数：

```
starttime %llu (was %lu before Linux 2.6)
    (22)  The  time  the process started after system boot.  In kernels before Linux 2.6, this value was expressed in jiffies.  
    Since Linux 2.6, the value is expressed in clock ticks (divide by sysconf(_SC_CLK_TCK)).
```

将其取出后除以系统的时钟频率，得到的就是以秒为单位的启动时间，这个时间是相对于系统启动时间的，实现如下：

```c
static uint64_t get_reaper_start_time_in_sec(pid_t pid)
{
    uint64_t clockticks;
    int64_t ticks_per_sec;

    clockticks = get_reaper_start_time(pid);
    if (clockticks == 0 && errno == EINVAL) {
        lxcfs_debug("failed to retrieve start time of pid %d\n", pid);
        return 0;
    }

    ticks_per_sec = sysconf(_SC_CLK_TCK);
    if (ticks_per_sec < 0 && errno == EINVAL) {
        lxcfs_debug(
            "%s\n",
            "failed to determine number of clock ticks in a second");
        return 0;
    }

    return (clockticks /= ticks_per_sec);
}
```

函数`sysconf()`的用法见：[系统配置->sysconf](https://www.lijiaocn.com/programming/chapter-c/sysconfig.html#sysconf)。

`/proc/[PID]/stat`文件的第22个字段的读取方法：

```c
static uint64_t get_reaper_start_time(pid_t pid)
{
    int ret;
    FILE *f;
    uint64_t starttime;
    /* strlen("/proc/") = 6
     * +
     * LXCFS_NUMSTRLEN64
     * +
     * strlen("/stat") = 5
     * +
     * \0 = 1
     * */
#define __PROC_PID_STAT_LEN (6 + LXCFS_NUMSTRLEN64 + 5 + 1)
    char path[__PROC_PID_STAT_LEN];
    pid_t qpid;

    qpid = lookup_initpid_in_store(pid);
    if (qpid <= 0) {
        /* Caller can check for EINVAL on 0. */
        errno = EINVAL;
        return 0;
    }

    ret = snprintf(path, __PROC_PID_STAT_LEN, "/proc/%d/stat", qpid);
    if (ret < 0 || ret >= __PROC_PID_STAT_LEN) {
        /* Caller can check for EINVAL on 0. */
        errno = EINVAL;
        return 0;
    }

    f = fopen(path, "r");
    if (!f) {
        /* Caller can check for EINVAL on 0. */
        errno = EINVAL;
        return 0;
    }

    /* Note that the *scanf() argument supression requires that length
     * modifiers such as "l" are omitted. Otherwise some compilers will yell
     * at us. It's like telling someone you're not married and then asking
     * if you can bring your wife to the party.
     */
    ret = fscanf(f, "%*d "      /* (1)  pid         %d   */
            "%*s "      /* (2)  comm        %s   */
            "%*c "      /* (3)  state       %c   */
            "%*d "      /* (4)  ppid        %d   */
            "%*d "      /* (5)  pgrp        %d   */
            "%*d "      /* (6)  session     %d   */
            "%*d "      /* (7)  tty_nr      %d   */
            "%*d "      /* (8)  tpgid       %d   */
            "%*u "      /* (9)  flags       %u   */
            "%*u "      /* (10) minflt      %lu  */
            "%*u "      /* (11) cminflt     %lu  */
            "%*u "      /* (12) majflt      %lu  */
            "%*u "      /* (13) cmajflt     %lu  */
            "%*u "      /* (14) utime       %lu  */
            "%*u "      /* (15) stime       %lu  */
            "%*d "      /* (16) cutime      %ld  */
            "%*d "      /* (17) cstime      %ld  */
            "%*d "      /* (18) priority    %ld  */
            "%*d "      /* (19) nice        %ld  */
            "%*d "      /* (20) num_threads %ld  */
            "%*d "      /* (21) itrealvalue %ld  */
            "%" PRIu64, /* (22) starttime   %llu */
             &starttime);
    if (ret != 1) {
        fclose(f);
        /* Caller can check for EINVAL on 0. */
        errno = EINVAL;
        return 0;
    }

    fclose(f);

    errno = 0;
    return starttime;
}
```

用当前时间减去进程的启动时间，就是进程的运行时长，当前时间需要是相对系统启动的时间，用系统调用`clock_gettime()`获取：

```c
static uint64_t get_reaper_age(pid_t pid)
{
    uint64_t procstart, uptime, procage;

    /* We need to substract the time the process has started since system
     * boot minus the time when the system has started to get the actual
     * reaper age.
     */
    procstart = get_reaper_start_time_in_sec(pid);
    procage = procstart;
    if (procstart > 0) {
        int ret;
        struct timespec spec;

        ret = clock_gettime(CLOCK_BOOTTIME, &spec);
        if (ret < 0)
            return 0;
        /* We could make this more precise here by using the tv_nsec
         * field in the timespec struct and convert it to milliseconds
         * and then create a double for the seconds and milliseconds but
         * that seems more work than it is worth.
         */
        uptime = spec.tv_sec;
        procage = uptime - procstart;
    }

    return procage;
}
```

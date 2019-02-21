# 并发编程
<!-- toc -->

## Once

设置只有第一次被调用时会执行的操作，`man pthread_once()`：

```c
#include <pthread.h>

int pthread_once(pthread_once_t *once_control,  void (*init_routine)(void));

pthread_once_t once_control = PTHREAD_ONCE_INIT;
```

## 线程锁

### 线程读写锁

#### 线程读写锁的创建初始化和销毁

创建初始化和销毁，`man pthread_rwlock_init`：

```c
#include <pthread.h>

int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
int pthread_rwlock_init(pthread_rwlock_t *restrict rwlock, 
       const pthread_rwlockattr_t *restrict attr);
```

#### 线程读写锁的加锁解锁操作

加读锁，`man pthread_rwlock_rdlock`：

```c
#include <pthread.h>

int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
```

加读锁等待超时，`man pthread_rwlock_timedrdlock`：

```c
#include <pthread.h>
#include <time.h>

int pthread_rwlock_timedrdlock(pthread_rwlock_t *restrict rwlock,
       const struct timespec *restrict abs_timeout);
```

加写锁，`man pthread_rwlock_wrlock`：

```c
#include <pthread.h>

int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock);
int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock);
```

加写锁等待超时，`man pthread_rwlock_timedwrlock`：

```c
#include <pthread.h>
#include <time.h>

int pthread_rwlock_timedwrlock(pthread_rwlock_t *restrict rwlock,
       const struct timespec *restrict abs_timeout);
```

解锁，`man pthread_rwlock_unlock`：

```c
#include <pthread.h>

int pthread_rwlock_unlock(pthread_rwlock_t *rwlock);
```

### 线程互斥锁

#### 线程互斥锁的创建初始化和销毁

创建初始化和销毁，`man pthread_mutex_init`：

```c
#include <pthread.h>

int pthread_mutex_destroy(pthread_mutex_t *mutex);
int pthread_mutex_init(pthread_mutex_t *restrict mutex,
       const pthread_mutexattr_t *restrict attr);

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
```

#### 线程互斥锁的加锁和解锁操作

加锁解锁，`man pthread_mutex_lock`：

```c
#include <pthread.h>

int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_trylock(pthread_mutex_t *mutex);
```

加锁等待超时，`man pthread_mutex_timedlock`：

```c
#include <pthread.h>
#include <time.h>

int pthread_mutex_timedlock(pthread_mutex_t *restrict mutex,
       const struct timespec *restrict abs_timeout);
```

解锁操作，`man pthread_mutex_unlock`：

```c
#include <pthread.h>

int pthread_mutex_unlock(pthread_mutex_t *mutex);
```

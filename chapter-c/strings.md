<!-- toc -->
# C语言中的字符串操作

编程过程中，如果不是在处理数值，就是在处理字符串。  by me ...

## 字符串长度

`man strlen`、`man strnlen`

```c
#include <string.h>

size_t strlen(const char *s);
size_t strnlen(const char *s, size_t maxlen);
```

`man wcslen`、`man wcsnlen`

```c
#include <wchar.h>

size_t wcslen(const wchar_t *s);
size_t wcsnlen(const wchar_t *s, size_t maxlen);
```

## 字符串比较

`man strcmp`

```c
#include <string.h>

int strcmp(const char *s1, const char *s2);

int strncmp(const char *s1, const char *s2, size_t n);
```

## 字符串复制

`man strdup`

```c
#include <string.h>

char *strdup(const char *s);

char *strndup(const char *s, size_t n);
char *strdupa(const char *s);
char *strndupa(const char *s, size_t n);
```

注意返回的是一个指针，指针指向的内存是用malloc函数分配的，不再使用的时候需要调用free函数释放。

## 按照指定的分隔符，将字符串分割

`man strtok`

```c
#include <string.h>

char *strtok(char *str, const char *delim);

char *strtok_r(char *str, const char *delim, char **saveptr);
```

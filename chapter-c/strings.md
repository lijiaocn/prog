# C语言中的字符串操作
<!-- toc -->

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

**注意**：

1. strtok是线程不安全的，线程安全需要使用strtok_r。
2. 传入的字符串的内容会被改写，用`\0`分割成了多个token，如果需要保留原先字符串，需要复制保留。

示例1：

```c
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[])
{
    char str[100];
    sprintf(str,"a b c d e f");
    char *delim = " ";
    char *token = NULL;

    token = strtok(str, delim);
    while (NULL != token) {
        printf("%s\n", token);
        token = strtok(NULL, delim);
    }

    return 0;
}
```

示例2:

```c
/*
 * main.c
 * Copyright (C) 2019 lijiaocn <lijiaocn@foxmail.com>
 *
 * Distributed under terms of the GPL license.
 */

#include <stdio.h>
#include <string.h>

#define str_iterate_parts(__iterator, __splitme, __separators)            \
    for (char *__p = NULL, *__it = strtok_r(__splitme, __separators, &__p); \
            (__iterator = __it);                                            \
            __iterator = __it = strtok_r(NULL, __separators, &__p))

int main(int argc, char *argv[])
{
	char str[100];
	sprintf(str,"a b c d e f");
	printf("before: %s\n", str);
	char *delim = " ";
	char *token = NULL;
	char *saveptr = NULL;

/*
	token = strtok_r(str, delim, &saveptr);
	while (NULL != token) {
		printf("%s\n", token);
		token = strtok_r(NULL, delim, &saveptr);
	}
*/

	int i = 0;
	str_iterate_parts(token, str, delim){
		if (i >= 3 ) break;
		printf("%s\n", token);
		i++;
	}
	printf("after : %s\n", str);

	return 0;
}
```

## 定位指定字符

```c
#include <string.h>

char *strchr(const char *s, int c);

char *strrchr(const char *s, int c);

#define _GNU_SOURCE         /* See feature_test_macros(7) */
#include <string.h>

char *strchrnul(const char *s, int c);
```

## 定位子字符串

```c
#include <string.h>

char *strstr(const char *haystack, const char *needle);

#define _GNU_SOURCE         /* See feature_test_macros(7) */

#include <string.h>

char *strcasestr(const char *haystack, const char *needle);
```

## 输入字符串转换

`man scanf` 

```c
#include <stdio.h>

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *str, const char *format, ...);

#include <stdarg.h>

int vscanf(const char *format, va_list ap);
int vsscanf(const char *str, const char *format, va_list ap);
int vfscanf(FILE *stream, const char *format, va_list ap);
```

fscanf和sscanf可能有妙用。

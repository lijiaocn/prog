<!-- toc -->
# Python3 的错误和异常处理方法

Python3 的运行错误以异常的方式抛出。

## 捕获异常

用 try...except...except...else...finally  捕获异常，支持同时处理多种类型的异常：

```python
import sys

try:
    f = open('myfile.txt')
    s = f.readline()
    i = int(s.strip())
except OSError as err:
    print("OS error: {0}".format(err))
except ValueError:
    print("Could not convert data to an integer.")
except:
    print("Unexpected error:", sys.exc_info()[0])
    raise
```

else 后面的语句是在没有异常时执行的语句，该语句必须在 except 之后：

```python
for arg in sys.argv[1:]:
    try:
        f = open(arg, 'r')
    except OSError:
        print('cannot open', arg)
    else:
        print(arg, 'has', len(f.readlines()), 'lines')
        f.close()
```

finally 中的语句无论是否发生异常，都要在离开 try 语句前执行，通常是清理操作：

```python
>>> try:
...     raise KeyboardInterrupt
... finally:
...     print('Goodbye, world!')
...
Goodbye, world!
KeyboardInterrupt
Traceback (most recent call last):
  File "<stdin>", line 2, in <module>
```

## 抛出异常

用 raise 主动抛出异常，抛出异常时，可以传入参数，之后通过异常变量的 args 获取：

```python
try:
    raise Exception('spam', 'eggs')
except Exception as inst:
    print(type(inst))    # the exception instance
    print(inst.args)     # arguments stored in .args
    print(inst)          # __str__ allows args to be printed directly,
                         # but may be overridden in exception subclasses
    x, y = inst.args     # unpack args
    print('x =', x)
    print('y =', y)
```

## 异常的种类

所有的异常源自 [Exception][1] 类，可以自定义异常：

```python
class InputError(Error):
    """Exception raised for errors in the input.

    Attributes:
        expression -- input expression in which the error occurred
        message -- explanation of the error
    """

    def __init__(self, expression, message):
        self.expression = expression
        self.message = message
```

## 带有自动清理的变量

有一些变量具有自我清理功能，配合 with 使用，例如下面的文件对象 f 会自动关闭：

```python
with open("myfile.txt") as f:
    for line in f:
        print(line, end="")
```

[1]: https://docs.python.org/3/library/exceptions.html#Exception  "exception Exception"

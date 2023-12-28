<!-- toc -->
# Python3 的模块

Python3 的代码以模块方式组织，一个模块对应一个以模块名命名的 py 文件，当前模块名存放在全局遍历 `__name__` 中。

## 模块的初始化

模块中包含直接执行的语句和函数定义，直接执行的语句在模块第一次导入的时候执行，相当于模块的初始化代码。

模块有单独私有符号表，模块的私有的符号表被模块内的函数当作全局的符号表。

导入模块：

```python
from fibo import fib, fib2
from fibo import *
import fibo as fib
from fibo import fib as fibonacci
```

## 模块的直接运行

直接执行模块文件时，从下面的 if 条件之后的语句开始执行：

```python
if __name__ == "__main__":
    import sys
    fib(int(sys.argv[1]))
```

## 模块的查找路径

python3 解析器遇到导入模块的语句时，首先查看导入的模块是否是 python3 的内置模块，然后到变量 sys.path 指定的目录中查找。

sys.path 中包含多个目录，默认目录顺序是：

* 当前模块文件所在的目录
* 环境变量 PYTHONPATH 指定的路径，默认是 prefix/lib/pythonversion，prefix 是 python 的安装路径
* python 的安装路径

当前目录中的模块如果与 python 标准库中的模块重名，后者被前者覆盖。


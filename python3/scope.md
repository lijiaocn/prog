<!-- toc -->
# Python 的作用域

Python 的命名空间（namespace）包括：

1. 内置的命名框架，包含内置的函数、变量、内置的异常
2. module 的 global namespace 
3. 函数的局部 namespace

## 变量的作用域

作用域（scope） 是具体的代码段，namespace 投射到 scope，

如果要使用上层作用域的变量，需要用 nonlocal 声明，否则只是在当前作用域创建一个同名变量，声明全局变量使用 global：

```python
spam = ""       # 当前作用域中的变量
nonlocal spam   # 上层作用域中的变量
global span     # 全局作用域中的变量
```

示例：

```python
def scope_test():
    def do_local():
        spam = "local spam"

    def do_nonlocal():
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)
```

运行输出为：

```
After local assignment: test spam
After nonlocal assignment: nonlocal spam
After global assignment: nonlocal spam
In global scope: global spam
```

## 类中变量的作用域

类属性的作用域是类，该类的所有实例使用同一份类属性，实例属性作用域是单个实例，每个实例一份。

例如下面的 kind 是类属性，name 是实例属性：

```python3
class Dog:

    kind = 'canine'         # class variable shared by all instances

    def __init__(self, name):
        self.name = name    # instance variable unique to each instance

>>> d = Dog('Fido')
>>> e = Dog('Buddy')
>>> d.kind                  # shared by all dogs
'canine'
>>> e.kind                  # shared by all dogs
'canine'
>>> d.name                  # unique to d
'Fido'
>>> e.name                  # unique to e
'Buddy'
```


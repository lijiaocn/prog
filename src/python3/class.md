<!-- toc -->
# Python3 的类的使用

和其它语言一样，Class 是 Python3 中语法最复杂的类型。

类的定义称为 Class，类的实例称为 Instance。

Python3 的内置函数 isinstance() 和 issubclass() 分别用来检查对象与类的关系、类的继承关系（对象所属的类记录在 `__class__` 属性中）。


## 类的定义

`__init__` 方法相当于构造函数，

```python
class MyClass:
    """A simple example class"""
    i = 12345

    def f(self):
        return 'hello world'

    def __init__(self, realpart, imagpart):
        self.r = realpart
        self.i = imagpart
```

类的实例化：

```python
x = MyClass(3.0, -4.5)
```

## 类属性

直接在类中定义的属性属于类变量：

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

## 类的继承

Python3 中的类支持多重继承：

```python
class DerivedClassName(Base1, Base2, Base3):
    <statement-1>
    .
    .
    .
    <statement-N>
```

在子类中，用 [super()][1] 方法调用父类的属性：

```python
class C(B):
    def __init__(self,url):
        super().__init__(url)
    def method(self, arg):
        super().method(arg)    # This does the same thing as:
                               # super(C, self).method(arg)
```

[Python’s super() considered super!][2] 对 super 有更多介绍。

## 迭代器

类的迭代器行为在 `__iter__` 和 `__next__` 中定义，`__iter__` 返回带有 `__next__`
的迭代器对象，`__next__` 返回下一个对象：

```python
class Reverse:
    """Iterator for looping over a sequence backwards."""
    def __init__(self, data):
        self.data = data
        self.index = len(data)

    def __iter__(self):
        return self

    def __next__(self):
        if self.index == 0:
            raise StopIteration
        self.index = self.index - 1
        return self.data[self.index]
```

## 参考

[1]: https://docs.python.org/3/library/functions.html#super "super"
[2]: https://rhettinger.wordpress.com/2011/05/26/super-considered-super/ "Python’s super() considered super!"

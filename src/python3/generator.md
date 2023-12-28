# Python3 的生成器 

使用 yield 语句构造的 Generator 可以被迭代：

```python
def reverse(data):
    for index in range(len(data)-1, -1, -1):
        yield data[index]
```

Generator 执行到 yield 语句时会暂停，直到遇到迭代时继续执行到下一个 yield 语句处暂停：

```python
>>> for char in reverse('golf'):
...     print(char)
...
f
l
o
g
```

Python3 的内置函数 range()、zip() 是生成器：

```python
>>> sum(i*i for i in range(10))                 # sum of squares
285

>>> xvec = [10, 20, 30]
>>> yvec = [7, 5, 3]
>>> sum(x*y for x,y in zip(xvec, yvec))         # dot product
260
```

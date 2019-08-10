# Python3 数据结构：set

Set 是一组没有顺序并且没有重复的值，支持交集、并集、差集、对称差集运算。

Set 创建：

```python
basket = {'apple', 'orange', 'apple', 'pear', 'orange', 'banana'}
a = set('abracadabra')
b = {x for x in 'abracadabra' if x not in 'abc'}
```

Set 运算：

```python
a - b       # 差集
a | b       # 并集
a & b       # 交集
a ^ b       # 对称差集，去掉同时位于 a 和 b 中的成员后剩余的成员
```

遍历排序的 set ：

```python
>>> basket = ['apple', 'orange', 'apple', 'pear', 'orange', 'banana']
>>> for f in sorted(set(basket)):
...     print(f)
```

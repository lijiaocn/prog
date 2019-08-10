# Python 数据结构：dictionary

Dictionary，就是 map，key-value 对。

字典的创建：

```python
dic1 = {'jack': 4098, 'sape': 4139}
dic2 = dict([('sape', 4139), ('guido', 4127), ('jack', 4098)])
dic3 = {x: x**2 for x in (2, 4, 6)}
dic4 = dict(sape=4139, guido=4127, jack=4098)
```

可以用 list 列出字典中的所有 key ，如果需要排序用 sorted：

```python
>>> list(tel)
['jack', 'guido', 'irv']
>>> sorted(tel)
['guido', 'irv', 'jack']
```

判断一个 key 是否存在用 in：

```python
>>> 'guido' in tel
True

>>> 'jack' not in tel
False
```

遍历字典时，使用 items() 获取  key-value：

```python
>>> knights = {'gallahad': 'the pure', 'robin': 'the brave'}
>>> for k, v in knights.items():
...     print(k, v)
```

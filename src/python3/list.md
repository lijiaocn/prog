<!-- toc -->
# Python3 的数据结构：List 列表

List 是可以修改的数组，支持嵌套。

## List 的创建

```python
list1 = ['orange', 'apple', 'pear', 'banana', 'kiwi', 'apple', 'banana']
list2 = []
```

用下面的方式创建 list 时需要一个命名变量 x：

```python
>>> squares = []
>>> for x in range(10):
...     squares.append(x**2)
...
>>> squares
[0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

可以用下面两种方式消除命名变量 x：

```python
squares = list(map(lambda x: x**2, range(10)))
squares = [x**2 for x in range(10)]
```

`[]` 支持多个 for 循环和条件判断，例如：

```python
>>> [(x, y) for x in [1,2,3] for y in [3,1,4] if x != y]
[(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]
```

等同于：

```python
>>> combs = []
>>> for x in [1,2,3]:
...     for y in [3,1,4]:
...         if x != y:
...             combs.append((x, y))
...
>>> combs
[(1, 3), (1, 4), (2, 3), (2, 1), (2, 4), (3, 1), (3, 4)]
```

## List 支持的方法

list 支持下面的方法：

```sh
list.append(x)         # 追加单个成员
list.extend(iterable)  # 将迭代器中成员全部追加到 list
list.insert(i, x)      # 在指定为未知插入成员，i 从 0 开始
list.remove(x)         # 删除 list 的第一个成员，如果为空，抛异常 ValueError
list.pop([i])          # 删除指定位置的成员并将其返回，如果没有指定 i 操作最后一个成员
list.clear()           # 清空
list.index(x,[start, [end])   # 返回相对于 start 的第 x 个成员，从 0 开始编号，end 是查找结束的位置
list.count(x)          # 返回 x 在列表中出现的次数
list.sort(key=None，reverse=False)  # 列表原地排序
list.reverse()         # 列表原地反转
list.copy()            # 复制列表
```

del 语句也能删除 list 的成员，例如：

```sh
del a[0]    # 删除 index 为 0 的成员
del a[2:4]  # 删除 index 为 2、3、4 的成员
del a[:]    # 清空 list
```

## 遍历 list

获取 索引和值，使用 enumerate()：

```python
>>> for i, v in enumerate(['tic', 'tac', 'toe']):
...     print(i, v)
```

同时遍历两个 list，用 zip()：

```python
>>> questions = ['name', 'quest', 'favorite color']
>>> answers = ['lancelot', 'the holy grail', 'blue']
>>> for q, a in zip(questions, answers):
...     print('What is your {0}?  It is {1}.'.format(q, a))
```

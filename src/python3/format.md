<!-- toc -->
# Python3 的 IO 操作 —— 格式化输出

Python3 支持多种格式化输出方法。

## 格式字符串

以 f 或者 F 开头的字符串中可以使用 python 表达式：

```sh
>>> year = 2016
>>> event = 'Referendum'
>>> f'Results of the {year} {event}'
'Results of the 2016 Referendum'
```

## str.format()

str.format() 可以用于格式化输出：

```sh
>>> yes_votes = 42_572_654
>>> no_votes = 43_132_495
>>> percentage = yes_votes / (yes_votes + no_votes)
>>> '{:-9} YES votes  {:2.2%}'.format(yes_votes, percentage)
' 42572654 YES votes  49.67%'
```

## 变量转换成字符串

str() 和 repr() 可以将任意变量转换成字符串，前者转换成可读的字符串，后者转换成可以被 解析执行的字符串：

```python
>>> s = 'Hello, world.'
>>> str(s)
'Hello, world.'
>>> repr(s)
"'Hello, world.'"
```

str() 的输出格式是  `__str__` 属性决定的：

```python
>>> class Point:
...     def __init__(self, x, y):
...         self.x, self.y = x, y
...     def __str__(self):
...         return 'Point({self.x}, {self.y})'.format(self=self)
...
>>> str(Point(4, 2))
'Point(4, 2)'
```

## 使用 %

%  的效果类似于 sprintf：

```python
>>> import math
>>> print('The value of pi is approximately %5.3f.' % math.pi)
The value of pi is approximately 3.142.
```

% 支持的占位符见 [printf-style String Formatting][2]：

## 格式化字符串使用的占位符

f 字符串和 str.format() 都用到{XX} 样式的占位符，python3 的占位符语法如下：

```sh
format_spec     ::=  [[fill]align][sign][#][0][width][grouping_option][.precision][type]
fill            ::=  <any character>
align           ::=  "<" | ">" | "=" | "^"
sign            ::=  "+" | "-" | " "
width           ::=  digit+
grouping_option ::=  "_" | ","
precision       ::=  digit+
type            ::=  "b" | "c" | "d" | "e" | "E" | "f" | "F" | "g" | "G" | "n" | "o" | "s" | "x" | "X" | "%"
```

占位符用法比较多（详情见 [Format Specification Mini-Language][1]），下面是几个例子：

变量匹配：

```python
>>> '{0}, {1}, {2}'.format('a', 'b', 'c')
'a, b, c'

>>> '{}, {}, {}'.format('a', 'b', 'c')  # 3.1+ only
'a, b, c'

>>> '{2}, {1}, {0}'.format('a', 'b', 'c')
'c, b, a'

>>> '{2}, {1}, {0}'.format(*'abc')      # unpacking argument sequence
'c, b, a'

>>> '{0}{1}{0}'.format('abra', 'cad')   # arguments' indices can be repeated
'abracadabra'

>>> coord = (3, 5)
>>> 'X: {0[0]};  Y: {0[1]}'.format(coord)
'X: 3;  Y: 5'

>>> 'Coordinates: {latitude}, {longitude}'.format(latitude='37.24N', longitude='-115.81W')
'Coordinates: 37.24N, -115.81W'

>>> coord = {'latitude': '37.24N', 'longitude': '-115.81W'}
>>> 'Coordinates: {latitude}, {longitude}'.format(**coord)
'Coordinates: 37.24N, -115.81W'

>>> c = 3-5j
>>> ('The complex number {0} is formed from the real part {0.real} '
...  'and the imaginary part {0.imag}.').format(c)
'The complex number (3-5j) is formed from the real part 3.0 and the imaginary part -5.0.'

>>> "repr() shows quotes: {!r}; str() doesn't: {!s}".format('test1', 'test2')
"repr() shows quotes: 'test1'; str() doesn't: test2"
```

对齐填充：

```python
>>>{:<30}'.format('left aligned')
'left aligned                '

>>> '{:<30}'.format('left aligned')
'left aligned                  '

>>> '{:>30}'.format('right aligned')
'                 right aligned'

>>> '{:^30}'.format('centered')
'           centered           '

>>> '{:*^30}'.format('centered')  # use '*' as a fill char
'***********centered***********'
```

显示精度：

```python
>>> '{:+f}; {:+f}'.format(3.14, -3.14)  # show it always
'+3.140000; -3.140000'
>>> '{: f}; {: f}'.format(3.14, -3.14)  # show a space for positive numbers
' 3.140000; -3.140000'
>>> '{:-f}; {:-f}'.format(3.14, -3.14)  # show only the minus -- same as '{:f}; {:f}'
'3.140000; -3.140000'
```

格式转换：

```python
>>> # format also supports binary numbers
>>> "int: {0:d};  hex: {0:x};  oct: {0:o};  bin: {0:b}".format(42)
'int: 42;  hex: 2a;  oct: 52;  bin: 101010'

>>> # with 0x, 0o, or 0b as prefix:
>>> "int: {0:d};  hex: {0:#x};  oct: {0:#o};  bin: {0:#b}".format(42)
'int: 42;  hex: 0x2a;  oct: 0o52;  bin: 0b101010'

>>> '{:,}'.format(1234567890)
'1,234,567,890'

>>> import datetime
>>> d = datetime.datetime(2010, 7, 4, 12, 15, 58)
>>> '{:%Y-%m-%d %H:%M:%S}'.format(d)
'2010-07-04 12:15:58'
```

## 参考

[1]: https://docs.python.org/3/library/string.html#formatspec "Format Specification Mini-Language"
[2]: https://docs.python.org/3/library/stdtypes.html#old-string-formatting "printf-style String Formatting"



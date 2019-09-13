<!-- toc -->
# Python3 字符串处理方法

List 拼接成字符串：

```python
list = ['a','b','c']
','.join(list)
```

字符串内容替换：

```python
str = 'abc123 / / 123'
str.replace('/',' ')
```

字符串正则替换：

```python
import re
...

str = 'abc123 / / 123'
res.sub('/s+',' ',str)
```

正则提取：

```python
content = "【hello】world"
match = re.match('【(.*)】', content, re.UNICODE)
if match:
	print match.group(1)
```

[1]: https://www.delftstack.com/zh/howto/python/how-to-remove-whitespace-in-a-string/ "Python 如何去掉字符串中的空白符"

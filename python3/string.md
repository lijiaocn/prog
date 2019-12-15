<!-- toc -->
# Python3 字符串处理方法

## 字符串处理

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

## 字符串转换

字符串转换成 byte 数组：

```python
s = "Hello, world!"   # str object 

print('str --> bytes')
print(bytes(s, encoding="utf8"))

b = b"Hello, world!"  # bytes object
print('\nbytes --> str')
print(str(b, encoding="utf-8"))
```

## json 字符串处理

序列化为 json 字符串：

```python
import json
di = dict(name='BOb', age=20, score=93)
json.dumps(di)
```

json 字符串反序列化：

```python
import json
json_str = '{"name": "BOb", "age": 20, "score": 93}'
json.loads(json_str)
```

## 参考

[1]: https://www.delftstack.com/zh/howto/python/how-to-remove-whitespace-in-a-string/ "Python 如何去掉字符串中的空白符"

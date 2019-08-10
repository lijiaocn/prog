<!-- toc -->
# Python3 的 IO 操作 —— 文件读写

Python3 内置的 open() 函数打开指定文件，并返回文件对象。

## open() 建议用法

open() 函数建议和 with 一起使用，使用 with 时，文件会在读写完成后自动关闭：

```python
>>> with open('workfile') as f:
...     read_data = f.read()
>>> f.closed
True
```

## 文件对象支持的方法

文件对象支持的方法:

```python
f.read()
f.readline()

for line in f:
    print(line, end='')

f.write('This is a test\n')
f.seek(5)      # Go to the 6th byte in the file
f.read(1)
f.seek(-3, 2)  # Go to the 3rd byte before the end
f.tell()       # 返回当前位置
```

## json 格式内容写入加载

json.dump(x,f) 将 x 序列化后写入文件 f，json.load(f) 将文件 f 中的 json 字符串加载并反序列化：

```python
import json
json.dump(x, f)
x = json.load(f)
```

<!-- toc -->
# 淘宝客API的SDK下载

在淘宝开放平台中，进入应用以后，在左侧边栏中有一个“SDK下载”的菜单，进入后，可以选择下载各种编程语言的SDK，目前支持：Java、PHP、Python、.NET、Metadata、C、NodeJS。

具体用法参考[淘宝客SDK的使用说明][1]。

## python sdk使用前准备

使用淘宝客的Python SDK的时候要注意，如果用的是Python3，直接使用会遇到错误：

```
name 'long' is not defined
```

这是因为python3中用[int取代了关键字long](https://stackoverflow.com/questions/14904814/nameerror-global-name-long-is-not-defined)，淘宝客的python sdk中top/api/base.py还在使用long：

```
P_TIMESTAMP: str(long(time.time() * 1000)),
```

将long修改位int：

```
P_TIMESTAMP: str(int(time.time() * 1000)),
```

但是淘宝客API中还有其它python2的用法，一个一个修改太麻烦了，可以用python提供的[2to3](https://docs.python.org/2/library/2to3.html)命令，将整个目录中的python2代码转换成python3：

```sh
$ 2to3 -w top
RefactoringTool: Skipping optional fixer: buffer
RefactoringTool: Skipping optional fixer: idioms
RefactoringTool: Skipping optional fixer: set_literal
RefactoringTool: Skipping optional fixer: ws_comma
RefactoringTool: No changes to top/__init__.py
...
```

转换之后还是会有一些错误，只能一个个修改：

### Unicode-objects must be encoded before hashing

```
sign = hashlib.md5(parameters).hexdigest().upper()
```

修改为：

```
sign = hashlib.md5(parameters.encode('utf-8')).hexdigest().upper()
```

### getsockaddrarg: AF_INET address must be tuple, not int

这是因为python3的http.client.HTTPConnection()的构造参数顺序发生了变化。

将代码：

```python
if(self.__port == 443):
	connection = http.client.HTTPSConnection(self.__domain, self.__port, None, None, False, timeout)
else:
	connection = http.client.HTTPConnection(self.__domain, self.__port, False, timeout)

```

修改为：

```python
if(self.__port == 443):
    connection = http.client.HTTPSConnection(host=self.__domain, port=self.__port, timeout=timeout)
else:
    connection = http.client.HTTPConnection(self.__domain, self.__port, timeout=timeout)
```

[1]: https://open.taobao.com/doc.htm?docId=101618&docType=1 "淘宝客SDK的使用说明"

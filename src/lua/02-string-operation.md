<!-- toc -->
# Lua的字符串操作

操作字符串，大概是比“标准输出”更常用的操作，朴素地讲，写代码就是在处理数字和字符串。

Lua有一个名为`string`的标准库：[String Manipulation][1]。

在OpenResty中，除了可以使用Lua的标准库，还可以使用[Nginx API for Lua](https://github.com/openresty/lua-nginx-module#nginx-api-for-lua)中的`ngx.re.match`、`ngx.re.find`、`ngx.re.gmatch`、`ngx.re.sub`和`ngx.re.gsub`。

## Lua的正则表达式语法

正则表达式不是一种标准的表示方法，不同语言、不同工具的正则表达式语法可能有差异。

Lua的[string标准库][1]使用的正则表达式的语法在[6.4.1 Patterns][2]中有详细说明。

Lua的正则表达式支持以下字符集合（Character Class）：

	^$()%.[]*+-?   这些字符以外的字符匹配的都是字符自身
	.              匹配所有字符
	%a             匹配所有字母
	%c             匹配所有控制字符
	%d             匹配所有数字
	%g             匹配空白字符以外的所有可打印字符
	%l             匹配所有的小写字母
	%p             匹配所有的标点符号
	%s             匹配所有的空白字符
	%u             匹配所有的大写字母
	%w             匹配所欲的字母和数字
	%x             匹配所有的十六进制数字
	%x             如果x不是字母和数字，那么匹配x本身，可以用这种方式匹配具有特殊含义的字符
	[set]          匹配set中出现过的字符，set中可以前面的字符匹配，例如%a等        
	[^set]         匹配set以外的字符，[set]字符集合的补集

对于用`%小写字母`表示的字符集合，对应的`%大写字母`是对应字符集合的补集。

Lua的正则表达式支持下面的模式单位（Pattern Item）：

	*              前面的字符出现0次以上，最长匹配 
	+              前面的字符出现1次以上，最长匹配
	-              前面的字符出现0次以上，最短匹配
	?              前面的字符出现1次
	%n             n为1-9的数字，分别表示第n个捕获的内容
	%bxy           x,y为不同的字符，匹配以x开头以y结尾的字符串，x和y是配对出现的，比如%b()
	%f[set]        匹配set中的字符第一次出现的地方

一个或多个模式单位组合成模式（Pattern），用`^`表示目标字符串的开始位置，用`$`表示目标字符串的结束位置。

正则表达式中可以嵌套正则，嵌套的正则位于`()`中，被嵌套的正则匹配的内容可以被捕获(Captures)，可以用%n提取第n个`(`对应的嵌套正则表达式匹配的内容。

例如`(a*(.)%w(%s*))`，%1是`a*(.)%w(%s*)`匹配的内容，%2是`(.)`匹配的内容，%3是`(%s*)`匹配的内容。

## 字符串正则匹配

[string.gmatch][3]用来对字符串做全局匹配，会对匹配后剩余的字符串继续匹配，直到字符串结束，以迭代器的方式返回每次匹配中捕获的字符串，如果正则表达式中没有捕获，返回整个正则表达式匹配的内容。

下面的代码，正则中没有有嵌套的正则：

```lua
print("-- single capature")
s = "hello world from Lua"
for w in string.gmatch(s, "%a+") do
    print(w)
end
```

执行结果如下：

	-- single capature
	hello
	world
	from
	Lua

正则表达式中有嵌套的正则，迭代器每次返回捕获的字符串：

```lua
print("-- multi capature")
s = "from=world, to=Lua, abc=1"
for k, v in string.gmatch(s, "(%w+)=(%w+)") do
    print(k,v)
end
```

执行结果如下：

	-- multi capature
	from	world
	to	Lua
	abc	1

与[string.gmatch][3]相对的是[string.match][5]，`string.match (s, pattern [, init])`只匹配一次，不对剩余的字符串继续匹配，可以通过第三个参数指定开始查找匹配的位置。

```lua
print("-- match at pos 5")
s= "123456789"
v=string.match(s,"%d*", 5)
print(v)
```

执行结果如下：

	-- match at pos 5
	56789

## 字符串正则替换

[string.gsub][4]，`string.gsub (s, pattern, repl [, n])`，将s中全部或者前n个匹配了pattern的字符串用repl替换，并作为一个新的字符串返回。

repl可以是字符串，字符串中可以使用`%n`指代捕获的内容，`%0`表示完整匹配，`%%`将%转义成普通字符。

repl可以是table，这时候替换的内容，是以捕获的字符串为key，从repl中读取出来的内容。

repl可以是function，这时候替换的内容，是以捕获的字符串为参数时，repl指代的函数的返回结果。

repl是table或者function时，如果得到的替换内容是false或nil，则不替换。

repl是字符串时：

```lua
print("-- repeat each word")
x = string.gsub("hello world", "(%w+)", "%1 , %1 |")
print(x)

print("-- repeat first word")
x = string.gsub("hello world", "(%w+)", "%1 , %1 |",1 )
print(x)
```

输出结果如下：

	-- repeat each word
	hello , hello | world , world |
	-- repeat first word
	hello , hello | world

reple是table时：

```lua
	print("-- repel is table")
	local t = {name="lua", version="5.3"}
	x = string.gsub("$name-$version.tar.gz", "%$(%w+)", t)
	print(x)
```

输出结果如下：

	-- reple is table
	lua-5.3.tar.gz

repl是函数时：

```lua
print("-- repel is a function")
x = string.gsub("home = $HOME, user = $USER", "%$(%w+)", os.getenv)
print(x)
```

输出结果如下：

	-- repel is a function
	home = /Users/lijiao, user = lijiao

需要注意的是[string.sub][6]和这里的[string.gsub][4]不是相对的关系，`string.sub (s, i [, j])`是取出s的第i个到第j个字符。

## 取字符串的子串

[string.sub][6]，`string.sub (s, i [, j])`取出字符串s的第i到j个字符，下标是从1开始计数的，j默认是-1 表示字符串的完整长度，i如果是负数，表示字符串的后|i|个字符：

```lua
print("-- sub string 0-3, 1-3, 2-3")
s="123456789"
v=string.sub(s,0,3)
print(v)
v=string.sub(s,1,3)
print(v)
v=string.sub(s,2,3)
print(v)
v=string.sub(s,2,-1)
print(v)
v=string.sub(s,-2)
print(v)
```

执行结果如下：

	-- sub string 0-3, 1-3, 2-3
	123
	123
	23
	23456789
	89

[1]: https://www.lua.org/manual/5.3/manual.html#6.4 "Lua 5.3: String Manipulation"
[2]: https://www.lua.org/manual/5.3/manual.html#6.4.1 "Lua 5.3: Patterns"
[3]: https://www.lua.org/manual/5.3/manual.html#pdf-string.gmatch "Lua 5.3: string.gmatch"
[4]: https://www.lua.org/manual/5.3/manual.html#pdf-string.gsub "Lua 5.3: string.gsub"
[5]: https://www.lua.org/manual/5.3/manual.html#pdf-string.match "Lua 5.3: string.match"
[6]: https://www.lua.org/manual/5.3/manual.html#pdf-string.sub "Lua 5.3: string.sub"

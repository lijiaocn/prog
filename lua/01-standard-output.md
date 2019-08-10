# Lua的标准输出
<!-- toc -->

在写代码的过程中，特别是开始学习一门语言的时候，最常用的功能就是“标准输出”：将变量的数值或者类型等，打印到屏幕上或者日志中，看一下是否符合预期。

下面的使用函数大多数都在第一次出现的时候，设置了超链接，连接到 [Lua5.3 Reference Manual](https://www.lua.org/manual/5.3/)，如果你使用的Lua版本是5.1，可以到 [Lua 5.1 Reference Manual](https://www.lua.org/manual/5.1/) 中查找这些函数的说明。

## 直接输出

[print\(···\)](https://www.lua.org/manual/5.3/manual.html#pdf-print) 函数是最简单的标准输出函数，它将所有出入参数打印出来，参数可以是任意类型，print函数用 [tostring](https://www.lua.org/manual/5.3/manual.html#pdf-tostring) 函数将输入参数转换成字符串。

>需要注意的是print函数不支持格式化输出。

下面这段代码展示了Lua中的不同类型的变量，用print输出是的效果：

```lua
local number=0.2
local string="this is a string"
local table = {first="value1",second="value2"}
local array = {"a","b","c"}

print("parameter is nil(", type(nil),")",nil)
print("parameter is boolen(", type(true),")",true)
print("parameter is number(", type(number),")", number)
print("parameter is string(", type(string),")", string)
print("parameter is function(", type(print),")",print)
print("parameter is userdata(", type(io.stdin),")", io.stdin)
print("parameter is table(", type(table),")", table)
print("parameter is array(", type(array),")", array)
```

输出如下：

```sh
parameter is nil(	nil	)	nil
parameter is boolen(	boolean	)	true
parameter is number(	number	)	0.2
parameter is string(	string	)	this is a string
parameter is table(	table	)	table: 0x7f828ec08860
parameter is array(	table	)	table: 0x7f828ec08930
parameter is function(	function	)	function: 0x7f828ec03e70
parameter is userdata(	userdata	)	file (0x7fffaa221110)
```

array是一种特殊的table，它们的区别在数据结构章节讲解，需要注意的是`table`、`function`和`userdata`类型，输出的都是地址。

## 格式化输出

[string.format](https://www.lua.org/manual/5.3/manual.html#pdf-string.format)函数，与ISO C的sprintf函数的用法基本相同，但是不支持修饰符`*`、`h`、 `L`、 `l`、 `n`、 `p`，增加了一个新的修饰符`q`。

`q`修饰符表示为字符串中字符添加转义字符，转换成可以被lua安全读取的样式：

```lua
print("-- format output")
v = string.format('%q', 'a string with "quotes" and \n new line')
print(v)
```

执行结果如下：

	-- format output
	"a string with \"quotes\" and \
	 new line"

## table的输出

对于table类型，我们更希望看到的是它里面存放的值，而不是它本身的地址。在Lua中输出table的内容比较麻烦，需要用 [pairs](https://www.lua.org/manual/5.3/manual.html#pdf-pairs) 函数遍历。

`pairs(t)`函数调用传入参数的名为`__pairs`的元方法遍历table中的成员，pairs可以遍历所有类型的table，另一个遍历函数 [ipairs](https://www.lua.org/manual/5.3/manual.html#pdf-ipairs) 只能遍历数组类型的table。

用pairs和ipairs遍历table：

```lua
local table = {first="value1",second="value2"}

print("--- iterate table by pairs  ")
for i, v in pairs(table) do
    print(i ,v)
end

print("--- iterate table by ipairs  ")
for i, v in ipairs(table) do
    print(i ,v)
end
```

结果如下，ipairs没有遍历输出：

	--- iterate table by pairs
	second	value2
	first	value1
	--- iterate table by ipairs

用pairs和ipairs遍历array类型的table：

```lua
	local array = {"a","b","c"}
	
	print("--- iterate array by pairs ")
	for i, v in pairs(array) do
	    print(i ,v)
	end
	
	print("--- iterate array by ipairs ")
	for i, v in ipairs(array) do
	    print(i ,v)
	end
```

结果如下，输出相同：

	--- iterate array by pairs 
	1	a
	2	b
	3	c
	--- iterate array by ipairs 
	1	a
	2	b
	3	c

ipairs事实是在用从1开始的下标，取出array类型table中的成员。


## 转换成json字符串输出

lua有很多个[json模块](http://lua-users.org/wiki/JsonModules)，可以考虑将table等类型的变量转换成json字符串后输出。

[json模块](http://lua-users.org/wiki/JsonModules)中的多个json模块，以及用luarocks命令找到的多个json模块，孰优孰略，我不能判定，

```bash
$ luarocks search json
json - Search results for Lua 5.1:
==================================

Rockspecs and source rocks:
---------------------------

dkjson
   2.5-2 (rockspec) - https://luarocks.org

...(省略)...
```

下面只演示"luajson"的用，安装方法如下：

```bash
$ luarocks install luajson
Installing https://luarocks.org/luajson-1.3.4-1.src.rock
...(省略)...
```

使用方法如下：

```lua
local json = require "json"

local table={first="value1", second="value2"}
v = json.encode(table)
print(v)

local array={"a","b","c",1,2,3}
v = json.encode(array)
print(v)
```

执行结果如下：

```json
{"second":"value2","first":"value1"}
["a","b","c",1,2,3]
```

<!-- toc -->
# Lua的基本数据类型

Lua是动态类型语言，函数`type()`返回一个变量或者一个值的类型：

	$ lua5.1
	Lua 5.1.5  Copyright (C) 1994-2012 Lua.org, PUC-Rio
	> print(type("hello world"))
	string

Lua的基本类型有：

	nil       空类型，表示无效值，变量在被赋值前都是nil，将nil赋给一个全局变量等同将其删除
	boolean   布尔类型，值为true/false，只有nil和false为“假”，其它如0和""都是真，这一点要特别特别注意！
	number    数字，值为实数，Lua默认为double，LuaJIT会根据上下文选择用整型或者浮点型存储
	string    字符串，支持单引号、双引号和长括号的方式
	table     表，关联数组
	function  函数
	userdata  用来保存应用程序或者C语言写的函数库创建的新类型。

## nil

nil类型需要注意的是： 变量在被赋值前都是nil，将nil赋给一个全局变量等同将其删除。

## boolean

布尔类型需要注意的是： 只有nil和false为“假”，其它如0和""都是真。

## number

Lua默认为double，LuaJIT会根据上下文选择整型或者浮点型。

整数和浮点数的类型都是number：

	> type(3)    --> number
	> type(3.5)  --> number
	> type(3.0)  --> number

如果非要区分整型和浮点数，可以用math中的type函数：

	> math.type(3)     --> integer
	> math.type(3.0)   --> float

## string

支持单引号、双引号和长括号的方式。

长括号的形式要特别说明，长括号是分正反的，正长括号就是两个`[`中间有任意个“=”，一个“=”表示一级，例如：

	[[          0级正长括号
	[=[         1级正长括号
	[===[       3级正长括号

它们分别和反长括号对应：

	]]          0级反长括号
	]=]         1级反长括号
	]===]       3级反长括号

一个字符串可以用任意级别的长括号开始，遇到同级别的反长括号时结束，`长括号中的所有字符不被转义`，包括其它级别的长括号，例如：

	> print([==[ string have a [=[ in ]=] ]==])
	string have a [=[ in ]=]

Lua中`字符串不能被修改`，如果要修改只能在原值的基础上新建一个字符串，也`不能通过下标访问字符串中的字符`。操作字符串可以用`String模块`中的方法。

所有的字符串都存放在一个全局的哈希表中，`相同的字符串只会存储一份`，因此创建多个内容相同的字符串，不会多占用存储空间，字符串比较是O(1)的。

## table

table是Lua唯一支持的数据结构，它是一个`关联数组`，一种有特殊索引的数组，索引可以是nil以外的任意类型的值。

下面是一个table的定义和使用：

```lua
local corp = {
    web = "www.google.com",   --索引是字符串，key = "web", value = "www.google.com"
    staff = {"Jack", "Scott", "Gary"}, --索引是字符串，值是一个table
    100876,              --相当于 [1] = 100876，索引为数字1，key = 1, value = 100876
    100191,              --相当于 [2] = 100191，索引为数字2
    [10] = 360,          --明确指定数字索引10
    ["city"] = "Beijing" --索引为字符串的另一种书写形式
}

print(corp.web)               -->output:www.google.com
print(corp.staff[1])          -->output:Jack
print(corp[2])                -->output:100191
print(corp[10])               -->output:360
print(corp["city"])           -->output:"Beijing"
```

Lua的table可能是用哈希表实现的，也可能是用数组实现的，或者两者的混合，根据table中的数值决定。

操作table的函数：

	table.remove
	table.concat

## array

Lua虽然只有一种数据结构`table`，但是可以通过为table添加数字索引的方式，实现数组。

一个新数组就是一个空的table，无法指定大小，可以不停的写入：

```lua
local a = {}    -- new array
for i = 1, 1000 do
    a[i] = 0 end
end
```

通过`a[i]`的方式读取，如果i超范围，返回nil。

通过`#`操作符，获得数组的长度：

```lua
print(#a) --> 1000
```

## function

函数Lua的基本类型，可以存储在变量中。

```lua
local function foo()
    print("in the function")
    --dosomething()
    local x = 10
    local y = 20
    return x + y
end

local a = foo    --把函数赋给变量

print(a())
```

`有名函数`就是将一个匿名函数赋给同名变量，下面的函数定义：

```lua
function foo()
end
```

等同于：

```lua
foo = function ()
end
```

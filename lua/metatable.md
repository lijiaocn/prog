# Lua的元表使用
<!-- toc -->

Lua5.1中，元表相当于重新定义操作符，类似于C++中的操作符重载。

## 元方法

元表是一组`元方法`组成的table，一些函数或模块的实现中调用的是元方法，可以实现不同的元方法实现不同的行为，而不更改调用这些元方法的函数或者模块的实现以及使用方式。

元方法有点类似于“接口”，lua支持以下元方法：

	"__add"         + 操作
	"__sub"         - 操作 其行为类似于 "add" 操作
	"__mul"         * 操作 其行为类似于 "add" 操作
	"__div"         / 操作 其行为类似于 "add" 操作
	"__mod"         % 操作 其行为类似于 "add" 操作
	"__pow"         ^ （幂）操作 其行为类似于 "add" 操作
	"__unm"         一元 - 操作
	"__concat"      .. （字符串连接）操作
	"__len"         # 操作
	"__eq"          == 操作 函数 getcomphandler 定义了 Lua 怎样选择一个处理器来作比较操作 仅在两个对象类型相同且有对应操作相同的元方法时才起效
	"__lt"          < 操作
	"__le"          <= 操作
	"__index"       取下标操作用于访问 table[key]
	"__newindex"    赋值给指定下标 table[key] = value
	"__tostring"    转换成字符串
	"__call"        当 Lua 调用一个值时调用
	"__mode"        用于弱表(week table)
	"__metatable"   用于保护metatable不被访问

`元方法`中第一个参数是`self`，下面是包含__index元方法的元表：

```lua
{__index = function(self, key)            --元表中重新实现了__index
    if key == "key2" then
      return "metatablevalue"
    end
  end
}
```

## 设置元表

元表要绑定到table变量，用函数`setmetatable(table, metatable)`设置，以设置__index元方法为例：

```lua
mytable = setmetatable({key1 = "value1"},   --原始表
  {__index = function(self, key)            --元表中重新实现了__index
    if key == "key2" then
      return "metatablevalue"
    end
  end
})
```

print(mytable.key1,mytable.key2)            --> output：value1 metatablevalue

`__index`元方法有点特殊，它可以是一个函数，也可以是一个table：

```lua
t = setmetatable({[1] = "hello"}, {__index = {[2] = "world"}})
print(t[1], t[2])   -->hello world
```

上面名为t的table中,t[2]是存放在元方法`__index`中的，当在t中找不到对应的key时，到`__index`中查找。
这个特性在面向对象编程用到。

函数`getmetatable(table)`可以读取table的元表。

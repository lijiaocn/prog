<!-- toc -->
# Lua的关键字和操作符

## 关键字

Lua区分大小写，例如and是保留关键字，但是And、AND等不是，可以作为标记符使用。

	and       break     do        else      elseif
	end       false     for       function  if
	in        local     nil       not       or
	repeat    return    then      true      until     while

## 操作符

	+     -     *     /     %     ^     #
	==    ~=    <=    >=    <     >     =
	(     )     {     }     [     ]
	;     :     ,     .     ..    ...

## 注释符

注释用`--`标记，一直作用到行尾。多行注释，在`--`后面跟随`[[`，一直作用到`]]`，例如：

```lua
--[[A multi-line
     long comment
]]
```

多行注释通常采用下面的样式：

```lua
--[[
    print(1)
    print(2)
    print(3)
--]]
```

## 语句分隔符

Lua语句之间可以使用“;”作为分隔符，但分隔符不是必须的，可以没有，另外换行符对lua来说不具备语法上的意义。

```lua
a = 1  b = a * 2    -- ugly, but valid
```

## 算术运算符

算术运算符有：

	+  -  *  /  ^（指数）  %（取模）

需要特别注意的是除法运算符`/`，它的结果是浮点数：

```lua
print(5/10)      --结果是0.2，不是0
```

Lua5.3引入了新的算数运算符`//`，取整除法（floor division），确保返回的是一个整数：

	> 3 // 2        --> 1
	> 3.0 // 2      --> 1.0
	> 6 // 2        --> 3
	> 6.0 // 2.0    --> 3.0
	> -9 // 2       --> -5
	> 1.5 // 0.5    --> 3.0

## 关系运算符

关系运算符有：

	<   >  <=  >=  ==  ~=（不等于）

特别注意，不等于用`~=`表示。

Lua中的`==`和`~=`，比较的是变量绑定对象是否相同，而不是比较绑定的对象的值。

下面两个变量a、b绑定的是两个相同值的对象，a和b是不等的：

```lua
local a = { x = 1, y = 0}
local b = { x = 1, y = 0}
if a == b then
  print("a==b")
else
  print("a~=b")
end

---output:
a~=b
```

## 逻辑运算符

逻辑运算符包括：

	and   or   not

逻辑运算符`and`和`or`的也需要特别注意，它们的结果不是0和1，也不是true和false，而是运算符两边的操作数中的一个：

```lua
a and b       -- 如果 a 为 nil，则返回 a，否则返回 b;
a or b        -- 如果 a 为 nil，则返回 b，否则返回 a。
```

总结一下就是：对于and和or，返回第一个使表达式的结果确定的操作数。

not的返回结果是true或者false。

## 字符串拼接

字符串拼接运算符是`..`，如果一个操作数是数字，数字被转换成字符串。

需要特别注意的是`..`每执行一次，都会创建一个新的字符串。

如果要将多个字符串拼接起来，为了高效，应当把它们写在一个table中，然后用`table.concat()`方法拼接。

```lua
local pieces = {}
for i, elem in ipairs(my_list) do
    pieces[i] = my_process(elem)
end
local res = table.concat(pieces)
```

## 运算符优先级

优先级如下，由高到底排序，同一行的优先级相同：

	^
	not  #   -
	*    /   %
	+    -
	..
	< >  <=  >=  ==  ~=
	and
	or

## 冒号语法糖

模块Account中实现了一个函数withdraw：

```lua
Account = {balance = 0}
function Account.withdraw (v)
  Account.balance = Account.balance - v
end
```

这个withdraw()函数中操作的是Account.balance，绑死了Account，这个方法只有Account能用。

实现一个能够操作任意调用者中的balance变量的方法，可以用下面的方法：

```lua
function Account.withdraw (self, v)
    self.balance = self.balance - v
end
```

可以用":"语法糖进行简化，省去self：

```lua
function Account:withdraw (v)
    self.balance = self.balance - v
end
```

冒号语法糖自动添加一个self形参，指向当前的调用者。

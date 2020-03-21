<!-- toc -->
# Lua的函数定义，传参注意事项和返回值

## 常用内置函数

[table.insert](https://www.lua.org/manual/5.3/manual.html#pdf-table.insert)： 将 value 插入 list[pos]，同时将后面的数值向后移动一位，如果没有指定 pos 添加到 list 尾部，post 默认为 #list+1。

```lua
table.insert (list, [pos,] value)
```

[ipairs (t)](https://www.lua.org/manual/5.3/manual.html#pdf-ipairs)：迭代器，遍历数组：

```lua
for i,v in ipairs(t) do body end  -- ipaires(t) 返回  (1,t[1]), (2,t[2]), ...,
```

[next](https://www.lua.org/manual/5.3/manual.html#pdf-next)：返回 table 中指定位置的元素。

```sh
next (table [, index])
```



## 声明定义

函数用关键字`function`定义，默认为全局的。

全局函数保存在全局变量中，会增加性能损耗，应当尽量使用局部函数，前面加上local：

```lua
local function function_name (arc)
  -- body
end
```

函数要定义后才能使用，定义代码在前面的。

可以函数定义时，直接设置为table的成员，如下：

```lua
function foo.bar(a, b, c)
    -- body ...
end
```

等同于：

```lua
foo.bar = function (a, b, c)
    print(a, b, c)
end
```

## 参数传递

非table类型的参数是`按值传递`的，table类型的参数传递的是引用。

调用函数时，如果传入的参数超过函数定义中的形参个数，多出的实参被忽略，如果传入的参数少于定义中的形参个数，没有被实参初始化的形参默认为nil。

变长参数用`...`表示，访问的时候也使用`...`：

```lua
local function func( ... )                -- 形参为 ... ,表示函数采用变长参数

   local temp = {...}                     -- 访问的时候也要使用 ...
   local ans = table.concat(temp, " ")    -- 使用 table.concat 库函数对数
                                          -- 组内容使用 " " 拼接成字符串。
   print(ans)
end
```

table类型的参数按引用传递，可以在函数修改它的值：

```lua
local function change(arg)             --change函数，改变长方形的长和宽，使其各增长一倍
  arg.width = arg.width * 2      --表arg不是表rectangle的拷贝，他们是同一个表
  arg.height = arg.height * 2
end                              -- 没有return语句了

local rectangle = { width = 20, height = 15 }

change(rectangle)
```

## 函数返回值

函数是多值返回的：

```lua
local function swap(a, b)   -- 定义函数 swap，实现两个变量交换值
   return b, a              -- 按相反顺序返回变量的值
end

local x = 1
local y = 20
x, y = swap(x, y)    
```

接收返回值的变量数量少于函数返回的值的数量时，多出的返回值被忽略，大于的时候，多出的接收变量被设置为nil。

在多变量赋值的列表表达式中，如果多值返回的函数不在最后一个，那么只有它的第一个返回值会被接收：

```lua
local function init()       -- init 函数 返回两个值 1 和 "lua"
    return 1, "lua"
end

local x, y, z = init(), 2   -- init 函数的位置不在最后，此时只返回 1
print(x, y, z)              -- output  1  2  nil

local a, b, c = 2, init()   -- init 函数的位置在最后，此时返回 1 和 "lua"
print(a, b, c)              -- output  2  1  lua
```

注意函数的传入参数也是列表表达式，遵循同样的规则，如下：

```lua
local function init()
    return 1, "lua"
end

print(init(), 2)   -->output  1  2
print(2, init())   -->output  2  1  lua
```

列表表达式中，如果要确保函数只返回一个值，用括号将函数包裹：

```lua
local function init()
    return 1, "lua"
end

print((init()), 2)   -->output  1  2
print(2, (init()))   -->output  2  1
```

## 函数回调

函数回调时，用unpack处理传入的变长参数：

```lua
local function run(x, y)
    print('run', x, y)
end

local function attack(targetId)
    print('targetId', targetId)
end

local function do_action(method, ...)
    local args = {...} or {}
    method(unpack(args, 1, table.maxn(args)))
end

do_action(run, 1, 2)         -- output: run 1 2
do_action(attack, 1111)      -- output: targetId    1111
```

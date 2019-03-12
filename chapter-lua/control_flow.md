# Lua的条件语句控制结构
<!-- toc -->

Lua支持下列控制结构：

	if
	while
	repeat
	for
	break
	return

## if

`if-then-end`:

```lua
x = 10
if x > 0 then
    print("x is a positive number")
end
```

`if-then-else-end`：

```lua
x = 10
if x > 0 then
    print("x is a positive number")
else
    print("x is a non-positive number")
end
```

`if-then-[elseif-then...]-else-end`：

```lua
score = 90
if score == 100 then
    print("Very good!Your score is 100")
elseif score >= 60 then
    print("Congratulations, you have passed it,your score greater or equal to 60")
--此处可以添加多个elseif
else
    print("Sorry, you do not pass the exam! ")
end
```

## while

注意Lua中没有`continue`语句， 只有`break`语句可以在循环结构中使用。

```lua
x = 1
sum = 0

while x <= 5 do
    sum = sum + x
    x = x + 1
end
print(sum)  -->output 15
```

## repeat

可以在循环结构中使用`break`：

```lua
x = 10
repeat
    print(x)
until false    -- 一直false，死循环
```

## for

for分数值for（numeric for）和范型for（generic for）。

### numeric for

数值for，就是设定一个开始数值，按照指定的跨度递增，直到结束值：

```lua
for i = 1, 5 do       -- 从1增长到5，默认每次增加1
  print(i)
end

for i = 1, 10, 2 do   -- 从1增长到10，明确设置每次增加2
  print(i)
end
```

如果跨度是负数，则递减：

```lua
for i = 10, 1, -1 do  -- 从10递减到1，每一次减去1
  print(i)
end
```

### generic for

范型for，就是用于迭代器（iterator）：

```lua
local a = {"a", "b", "c", "d"}
for i, v in ipairs(a) do
  print("index:", i, " value:", v)
end
```

`ipairs()`是遍历数组的迭代器函数，i是索引值，v是索引对应的数值。

for支持的迭代器还有：

	io.lines         迭代每行
	paris            迭代table
	ipairs           迭代数组元素
	string.gmatch    迭代字符串中的单词

[ipairs](https://www.lua.org/manual/5.3/manual.html#pdf-ipairs)是直接迭代，而[pairs](https://www.lua.org/manual/5.3/manual.html#pdf-pairs)是调用元方法`__pairs`，如果没有设置该原方法，则用next函数取下一个数值。

>在 LuaJIT 2.1 中，ipairs() 函数是可以被 JIT 编译执行的，而 pairs() 则只能被解释执行。

## break

break用于终止循环。

## return

return用于从函数中返回结果，在函数中使用return的时候，需要用`do-end`：

```lua
local function foo()
    print("before")
    do return end
    print("after")  -- 这一行语句永远不会执行到
end
```

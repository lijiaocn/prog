# Lua编程时尽量少创建变量

假设要存放多边形的多个顶点，每个顶点一个x坐标，一个y坐标。

方式一，每个顶点分配一个table变量：

```lua
polyline = { { x = 10.3, y = 98.5 },
             { x = 10.3, y = 18.3 },
             { x = 15.0, y = 98.5 },
             ...
           }
```

方式二，每个顶点分配一个数组变量，开销要比第一种方式少：

```lua
polyline = { { 10.3, 98.5 },
             { 10.3, 18.3 },
             { 15.0, 98.5 },
             ...
           }
```

方式三，将x坐标和y坐标分别存放到两个数组的中，一共只需要两个数组变量，开销更少：

```lua
polyline = { x = { 10.3, 10.3, 15.0, ...},
             y = { 98.5, 18.3, 98.5, ...}
           }
```

要有意思的的优化代码，尽量少创建变量。

## 在循环外部创建变量

如果在循环内创建变量，那么每次循环都会创建变量，导致不必要的创建、回收：

在循环内创建变量，var_inloop.lua：

```lua
function foo ()
	for i = 1, 10000000 do
		local t = {0}
		t[1]=i
	end
end

foo()

```

在循环外创建变量，var_outloop.lua：

```lua
local t={0}
function foo ()
	for i = 1, 10000000 do
		t[1] = i
	end
end

foo()
```

这两段代码的运行时间不是一个数量级的：

```bash
➜  03-performance git:(master) ✗ time lua-5.1 var_inloop.lua
lua-5.1 var_inloop.lua  3.41s user 0.01s system 99% cpu 3.425 total

➜  03-performance git:(master) ✗ time lua-5.1 var_outloop.lua
lua-5.1 var_outloop.lua  0.22s user 0.00s system 99% cpu 0.224 total
	
```

变量是这样的，函数也是如此：

```lua
local function aux (num)
	num = tonumber(num)
	if num >= limit then return tostring(num + delta) end
end
	
for line in io.lines() do
	line = string.gsub(line, "%d+", aux)
	io.write(line, "\n")
end
```

不要用下面的这种方式：

```lua
for line in io.lines() do
	line = string.gsub(line, "%d+", 
	     function (num)
	         num = tonumber(num)
	         if num >= limit then return tostring(num + delta) 
	     end
	)
	io.write(line, "\n")
end
```

## 尽量在字符串上创建分片

能用分片表示字符串，就不要创建新的字符串。

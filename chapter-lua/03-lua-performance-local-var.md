# Lua的局部变量比全局变量快30%

Lua代码是被解释执行的，Lua代码被解释成Lua虚拟机的指令，交付给Lua虚拟机执行。

Lua虚拟机不是对常见的物理计算机的模拟，而是完全定义了自己的规则。Lua虚拟机中虚拟了寄存器，但是它的寄存器是和函数绑定的一起的，并且每个函数可以使用高达250个虚拟寄存器（使用栈的方式实现的）。

操作局部变量时，使用的指令非常少，例如`a=a+b`只需要一条指令`ADD 0 0 1`。

如果`a`和`b`是全局变量，则需要四条指令：

	GETGLOBAL       0 0     ; a
	GETGLOBAL       1 1     ; b
	ADD             0 0 1
	SETGLOBAL       0 0     ; a

下面两段代码var_global.lua和var_local.lua性能相差30%：

var_global.lua：

```lua
for i = 1, 1000000 do
local x = math.sin(i)
end
```

var_local.lua：

```lua
local sin = math.sin
for i = 1, 1000000 do
local x = sin(i)
end
```

运行耗时占比：

```bash
➜  03-performance git:(master) ✗ time lua5.1 ./var_global.lua
lua5.1 ./var_global.lua  8.02s user 0.01s system 99% cpu 8.036 total

➜  03-performance git:(master) ✗ time lua5.1 ./var_local.lua
lua5.1 ./var_local.lua  6.01s user 0.01s system 99% cpu 6.026 total
```

因此在阅读使用lua代码时，经常看到下面的做法，将其它包中的变量赋值给本地变量：

```lua
local sin = math.sin
function foo (x)
  for i = 1, 1000000 do
    x = x + sin(i)
  end
  return x
end

print(foo(10))
```


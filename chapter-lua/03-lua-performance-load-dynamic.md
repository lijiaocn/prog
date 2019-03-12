# 在Lua程序中动态加载代码非常慢

Lua中可以用[load](http://www.lua.org/manual/5.1/manual.html#pdf-load)、[load](http://www.lua.org/manual/5.1/manual.html#pdf-loadfile)和[loadstring](http://www.lua.org/manual/5.1/manual.html#pdf-loadstring)动态加载代码并执行。应当尽量避免这种用法，动态加载代码需要被立即编译，编译开销很大。

load_dynamic.lua：

```lua
local lim = 10000000
local a = {}
for i = 1, lim do
	a[i] = loadstring(string.format("return %d", i))
end
print(a[10]())  --> 10
```

load_static.lua：

```lua
function fk (k)
	return function () return k end
end

local lim = 10000000
local a = {}
for i = 1, lim do
	a[i] = fk(i)
end

print(a[10]())  --> 10
```

上面两段代码的性能完全不同，后者耗时只有前者的十分之一：

```bash
➜  03-performance git:(master) ✗ time lua-5.1 ./load_dynamic.lua
10
lua-5.1 ./load_dynamic.lua  47.99s user 3.81s system 99% cpu 52.069 total

➜  03-performance git:(master) ✗ time lua-5.1 ./load_static.lua
10
lua-5.1 ./load_static.lua  4.66s user 0.62s system 99% cpu 5.308 total
```


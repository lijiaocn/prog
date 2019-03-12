# Lua中table类型变量的容量扩增代价很高

Lua的table是由`数组部分（array part）`和`哈希部分（hash part）`组成。数组部分索引的key是1~n的整数，哈希部分是一个哈希表（open address table）。

向table中插入数据时，如果已经满了，Lua会重新设置数据部分或哈希表的大小，容量是成倍增加的，哈希部分还要对哈希表中的数据进行整理。

需要特别注意的没有赋初始值的table，数组和部分哈希部分默认容量为0。

```lua
local a = {}     --容量为0
a[1] = true      --重设数组部分的size为1
a[2] = true      --重设数组部分的size为2
a[3] = true      --重设数组部分的size为4

local b = {}     --容量为0
b.x = true       --重设哈希部分的size为1
b.y = true       --重设哈希部分的size为2
b.z = true       --重设哈希部分的size为4
```

因为容量是成倍增加的，因此越是容量小的table越容易受到影响，每次增加的容量太少，很快又满。

对于存放少量数据的table，要在创建table变量时，就设置它的大小，例如：

table_size_predefined.lua：

```lua
for i = 1, 1000000 do
  local a = {true, true, true}   -- table变量a的size在创建是确定
  a[1] = 1; a[2] = 2; a[3] = 3   -- 不会触发容量重设
end
```

如果创建空的table变量，插入数据时，会触发容量重设，例如：

table_size_undefined.lua：

```lua
for i = 1, 1000000 do
  local a = {}                   -- table变量a的size为0
  a[1] = 1; a[2] = 2; a[3] = 3   -- 触发3次容量重设
end
```

后者耗时几乎是前者的两倍：

```bash
➜  03-performance git:(master) ✗ time lua-5.1 table_size_predefined.lua
lua-5.1 table_size_predefined.lua  4.17s user 0.01s system 99% cpu 4.190 total

➜  03-performance git:(master) ✗ time lua-5.1 table_size_undefined.lua
lua-5.1 table_size_undefined.lua  7.63s user 0.01s system 99% cpu 7.650 total
```
对于哈希部分也是如此，用下面的方式初始化:

	local b = {x = 1, y = 2, z = 3}


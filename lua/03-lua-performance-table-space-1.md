# 只有向table插入数据时，才有可能触发rehash

table只有在满的情况下，继续插入的数据的时候，才会触发rehash。如果将一个table中的数据全部设置为nil，后续没有插入操作，这个table的大小会继续保持原状，不会收缩，占用的内存不会释放。
除非不停地向table中写入nil，写入足够多的次数后，重新触发rehash，才会发生收缩：

```lua
a = {}
lim = 10000000

for i = 1, lim do a[i] = i end            --  create a huge table
print(collectgarbage("count"))            --> 196626

for i = 1, lim do a[i] = nil end          --  erase all its elements
print(collectgarbage("count"))            --> 196626，不会收缩

for i = lim + 1, 2*lim do a[i] = nil end  --  create many nil element
print(collectgarbage("count"))            --> 17，添加足够多nil之后才会触发rehash
```

**不要用这种方式触发rehash**，如果想要释放内存，就直接释放整个table，不要通过清空它包含的数据的方式进行。

将table中的成员设置为nil的时候，不触发rehash，是为了支持下面的用法：

```lua
for k, v in pairs(t) do
  if some_property(v) then
    t[k] = nil    -- erase that element
  end
end
```

如果每次设置nil都触发rehash，那么上面的操作就是一个灾难。

## 清理table中的所有数据时，用pairs，不要用next

如果要在保留table变量的前提下，清理table中的所有数据，一定要用[pairs()](http://www.lua.org/manual/5.1/manual.html#pdf-pairs)函数，不能用[next()](http://www.lua.org/manual/5.1/manual.html#pdf-next)。

next()函数是返回中的table第一个成员，如果使用下面方式，next()每次从头开始查找第一个非nil的成员：

```lua
while true do
	local k = next(t)
	if not k then break end
	t[k] = nil
end
```

正确的做法是用`pairs`：

```lua
for k in pairs(t) do
	t[k] = nil
end
```

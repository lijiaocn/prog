# Lua编程时慎用字符串拼接

Lua中的字符串是非常不同的，它们全部是内置的（internalized），或者说是全局的，变量中存放的是字符串的地址，并且每个变量索引的都是全局的字符串，没有自己的存放空间。

例如下面的代码，为变量a和变量b设置了同样的内容的字符串"abc"，"abc"只有一份存在，a和b引用的是同一个：

	local a = "abc"
	local b = "abc"

如果要为a索引的字符串追加内容，那么会创建一个新的全局字符串：

	a = "abc" .. "def"

创建全局字符串的开销是比较大的，在lua中慎用字符串拼接。

如果一定要拼接，将它们写入table，然后用`table.contat()` 连接起来，如下：

```lua
local t = {}
for line in io.lines() do
  t[#t + 1] = line
end

s = table.concat(t, "\n")
```


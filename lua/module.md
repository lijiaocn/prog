<!-- toc -->
# Lua的代码组织方式：模块

模块在[编程语言Lua（一）：入门介绍、学习资料、项目管理与调试方法-Lua Module][2]中有介绍。

Lua创建一个模块最简单的方法是：创建一个table，并将所有需要导出的函数放入其中，返回这个table。

例如模块my对应的my.lua文件内容如下：

```lua
local foo={}

local function getname()
    return "Lucy"
end

function foo.greeting()
    print("hello " .. getname())
end

return foo
```

模块my的greeting函数可以被调用：

```lua
local fp = require("my")
fp.greeting()     -->output: hello Lucy
```

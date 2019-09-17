<!-- toc -->
# Lua的面向对象设计方法

Lua的面向对象设计方法很不直观，Lua中的类就是模块，借助元表使模块具有了类的属性，能够实例化。

## 类的实现

Lua中类的实现方法，一个模块文件account.lua内容如下：

```lua
local _M = {}

local mt = { __index = _M }

function _M.deposit (self, v)
    self.balance = self.balance + v
end

function _M.withdraw (self, v)
    if self.balance > v then
        self.balance = self.balance - v
    else
        error("insufficient funds")
    end
end

function _M.new (self, balance)
    balance = balance or 0
    return setmetatable({balance = balance}, mt)
end

return _M
```

类的方法在`_M`表中，而_M表又被赋给了元方法`__index`，包含__index方法的元表mt被绑定到类实例化时创建的table变量，绑定了元表mt的table变量就是类的对象。

模块account.lua返回的是`_M`，调用_M中的new方法的时候，模块中的元表mt绑定到到一个新的table变量，传入的参数也被写入了这个新的table变量中（{balance = balance}），返回的table就可以调用mt中的方法和传入的参数。

```lua
local account = require("account")

local a = account:new()
a:deposit(100)

local b = account:new()
b:deposit(50)

print(a.balance)  --> output: 100
print(b.balance)  --> output: 50
```

总结一下，在Lua中类的实现方法：

	1. 创建一个模块
	2. 在模块中创建一个元表，__index元方法就是模块本身
	3. 在模块中创建一个new()函数，返回绑定了模块中的元表的table类型的变量。

## 继承

继承的实现就更麻烦了....

实现一个父类，就是一个普通的类，实现了方法`upper()`：

```lua
-- 父类 s_base.lua
local _M = {}

local mt = { __index = _M }

function _M.upper (s)
    return string.upper(s)
end

return _M
```

子类的实现，子类引用父类所在的模块，将父类作为子类__index元方法，子类只实现了方法`lower()`：

```lua
--子类 s_more.lua，引入了父类对应的模块
local s_base = require("s_base")

local _M = {}
_M = setmetatable(_M, { __index = s_base })


function _M.lower (s)
    return string.lower(s)
end

return _M
```

子类的对象既能使用子类中的`lower()`，也能使用父类中的`upper()`。

```lua
local s_more = require("s_more")

print(s_more.upper("Hello"))   -- output: HELLO
print(s_more.lower("Hello"))   -- output: hello
```

## 私有成员

私有成员的实现非常trick，下面的例子中实现了私有成员balance：

```lua
function newAccount (initialBalance)
    local self = {balance = initialBalance}
    local withdraw = function (v)
        self.balance = self.balance - v
    end
    local deposit = function (v)
        self.balance = self.balance + v
    end
    local getBalance = function () return self.balance end
    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
    }
end

a = newAccount(100)
a.deposit(100)
print(a.getBalance()) --> 200
print(a.balance)      --> nil
```

newAccount()返回的table中只有`withdraw`、`deposit`和`getBalance`，这三个方法都操作同一个隐藏的table，这个隐藏的table中的成员就是私有成员。感觉很不直观，但是似乎揭示了面向对象的本质...

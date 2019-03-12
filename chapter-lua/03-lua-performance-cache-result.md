# 缓存运行结果，减少运算

```lua
function memoize (f)
    local mem = {}                       -- memoizing table
    setmetatable(mem, {__mode = "kv"})   -- make it weak
    return function (x)       -- new version of ’f’, with memoizing
        local r = mem[x]
        if r == nil then      -- no previous result?
            r = f(x)          -- calls original function
            mem[x] = r        -- store result for reuse
        end
        return r
    end
end
```

用`memoize()`创建的函数的运算结果可以被缓存：

```lua
loadstring = memoize(loadstring)
```


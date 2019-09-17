<!-- toc -->
# Lua编程时性能方面的注意事项

[Lua Performance Tips](https://www.lua.org/gems/sample.pdf)给出了很重要的性能优化建议，这些建议都是用Lua编程时需要注意的事项。

* [局部变量比全局变量快30%](chapter1/03-lua-performance-local-var.md)
* [动态加载代码非常慢](chapter1/03-lua-performance-load-dynamic.md)
* [table的自动扩容代价很高](chapter1/03-lua-performance-table-space.md)
* [清理操作不会触发rehash](chapter1/03-lua-performance-table-space-1.md)
* [慎用字符串拼接](chapter1/03-lua-performance-string.md)
* [尽量少创建变量](chapter1/03-lua-performance-less-var.md)
* [缓存运算结果](chapter1/03-lua-performance-cache-result.md)
* [主动控制垃圾回收](chapter1/03-lua-performance-garbage-collect.md)

## 参考

1. [Nginx、OpenResty、Lua与Kong](https://www.lijiaocn.com/nginx/)
2. [What can I do to increase the performance of a Lua program?](https://stackoverflow.com/questions/154672/what-can-i-do-to-increase-the-performance-of-a-lua-program)
3. [Lua Performance Tips](http://www.lua.org/gems/sample.pdf)
4. [Lua Optimisation Tips](http://lua-users.org/wiki/OptimisationTips)
5. [luajit官方性能优化指南和注解](https://www.cnblogs.com/zwywilliam/p/5992737.html)
6. [Numerical Computing Performance Guide](http://wiki.luajit.org/Numerical-Computing-Performance-Guide)

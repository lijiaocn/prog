# Go 语言深入理解

参考：[Go 语言官方 10 年博文阅读指引][2]

Go 语言深度入门手册，帮你更好的理解 Go 语言，写出更高效、更规范、更不易出错的代码。

Go 在 2012 年发布 1.0 版本，距今已经 8 年了。和历史悠久近乎一成不变的 C 等编程语言不同，8 年里从 1.0 到 1.13，Go 语言在一刻不停地进化。从语法微调到性能大幅优化，代码的组织方式和配套工具等也几经变化。这意味着我们对 Go 对认知需要不停地刷新。Go 2 的设计早已提上日程，意味着 Go 1 开始趋稳，是重新整理认知的好机会。

学习 C 语言的时候，林锐博士撰写的小册子[《高质量 C++/C 编程指南》][3]广为流传：

![林锐：《高质量 C++/C 编程指南》](./img/c-linrui.png)

这本小册子让我意识到，掌握语法和能写出高质量的代码，完全是两回事。对 Go 语言来说应该是一样的，掌握了语法不等于能写出高效、不易出错的代码。并且高级语言往往让我们有一种错觉，以为用了它以后不再需要仔细考虑很多细节，实际情况却是我们需要考虑更多新的细节，旧问题装进了新瓶子。

>写纯 C 代码时从来没有想过垃圾回收的问题，得知 java 以及早期的 go 语言在 gc 时候会全局 pause 时，无比震惊！竟然还有这种事......
>
>这方面的问题复杂到有一个名为 International Symposium on Memory Management (ISMM) 的专门组织。Go 的核心开发人员 Rick Hudson 曾经在该组织介绍过 Go gc 的演变过程：[The Journey of Go's Garbage Collector][6]。

Go 网站上的 [《Effective Go》][4] 和 [Go Blog][5] 上的大量文章，无疑是最好的 Go 高质量编程指南，但是正如很难通过 Go 语言的语法定义[《The Go Programming Language Specification》][7] 学习 Go 编程，没有一定的知识储备，从《Effective Go》和 Go Blog 中汲取营养会比较吃力。

所以，一本「垫脚石」手册的存在会很有意义。

这本手册的内容非常非常浅，像「Go 的调度器如何设计」以及「三色标记算法」这种我不会的问题不会涉及。这里更关注代码如何组织，测试用例如何写，以及传参时应该注意的事项等常识性内容。相比「编程入门」，内容又比较深，所以叫做「深度入门」。

>如果要了解 Go 的实现，还有比「面向信仰编程」大神的 [《Go 语言设计与实现》][8]更好的入门资料吗？

绝大部分内容来自 Go 的博客（[Go 语言官方 10 年博文阅读指引][2]），不能保证这里的内容「永远正确」，也不保证更新频率，Go 的官网才应当是你永生的挚爱。

>真相时刻：所有细节都忘了，需要重新整理...... 😭 

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2019/12/23/go-blog-10-years.html "Go 语言官方 10 年博文"
[3]: https://vrlab.org.cn/~zhuq/download/%E9%AB%98%E8%B4%A8%E9%87%8F%E7%BC%96%E7%A8%8B%E6%8C%87%E5%8D%97.pdf "林锐：《高质量 C++/C 编程指南》"
[4]: https://golang.org/doc/effective_go.html "Effective Go"
[5]: https://blog.golang.org/index "The Go Blog"
[6]: https://blog.golang.org/ismmkeynote "The Journey of Go's Garbage Collector"
[7]: https://golang.org/ref/spec "The Go Programming Language Specification"
[8]: https://draveness.me/golang/ "Go 语言设计与实现"

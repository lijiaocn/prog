<!-- toc -->
# go程序的初始化

## 变量初始化为对应类型的零值

例如：

	type T struct { i int; f float64; next *T }
	t := new(T)

初始化值为：

	t.i == 0
	t.f == 0.0
	t.next == nil

## 包的初始化

下面的代码中，变量的初始化顺序为：d、b、c、a。

	var (
		a = c + b
		b = f()
		c = f()
		d = 3
	)

	func f() int {
		d++
		return d
	}

init函数：

	init() { … }

## 开始执行

	func main() { … }

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

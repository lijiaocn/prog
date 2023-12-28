<!-- toc -->
# go的错误处理

## 返回的错误值

	type error interface {
		Error() string
	}

## panic的传入参数类型

	package runtime
	
	type Error interface {
		error
		// and perhaps other methods
	}




## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

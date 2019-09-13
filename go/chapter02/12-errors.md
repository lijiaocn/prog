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




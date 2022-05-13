<!-- toc -->
# Gin 快速开始

建议直接使用 Go 1.13 以及以上版本，用 go mod 进行依赖管理（[代码要如何组织?](../article/pkg.md))。

## 示范代码

示范代码下载方法：

```sh
git clone https://github.com/introclass/go-code-example.git
```

然后在 IntelliJ IDEA、goLand 或其它习惯使用的 IDE 中创建一个新项目，导入目录 go-code-example，如果是 IntelliJ IDEA，注意勾选 go module。

## 使用 Gin 生成的 Handler

在这里 Gin 唯一的作用就是为 http.Server 提供一个 Handler，`r := gin.Default()`，在这个 Handler 中注入了对应的 HandlerFunc：

```go
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	//r.Run() // listen and serve on 0.0.0.0:8080
	s := &http.Server{
		Addr:           ":8080",
		Handler:        r,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20,
	}
	s.ListenAndServe()
```

完整代码：[ginusage/01quickstart](https://github.com/introclass/go-code-example/tree/master/ginusage/01quickstart)

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

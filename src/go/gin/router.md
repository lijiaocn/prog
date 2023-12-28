<!-- toc -->
# Gin 的 router 管理

这里所说的路由就是就是 http 请求的 method、path 与处理函数的对应关系。

Gin 的路由设置方法非常简单，处理函数定义如下（只有一个传入参数）：

```go
type HandlerFunc func(*Context)
```

下面的 echo 就是一个处理函数，它用 c.JSON() 向请求端发送了响应数据。

```go
func echo(c *gin.Context) {
    c.JSON(200, gin.H{
        "method": c.Request.Method,
        "uri":    c.Request.URL.String(),
    })
}
```

## 按照 method 设置

```go
router := gin.Default()

router.GET("/get", echo)
router.POST("/post", echo)
router.PUT("/put", echo)
router.DELETE("/delete", echo)
router.PATCH("/patch", echo)
router.HEAD("/head", echo)
router.OPTIONS("/option", echo)
```

## router 分组

上面平铺的设置方法有时候不能满足我们的需要，譬如当 API 有版本的时候， 我们希望能够分组处理：

```go
groupv1 := router.Group("/v1")
{
    groupv1.GET("/hello", echo)
}

groupv2 := router.Group("/v1")
{
    groupv2.GET("/hello", echo)
}
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

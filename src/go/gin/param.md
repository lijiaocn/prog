<!-- toc -->
# Gin 的请求参数获取

http 的请求参数通常通过以下集中方式传入。

* 附加在 url 后面的（用 ? 分隔）的 query 参数，譬如下面的 name 和 age：

```sh
127.0.0.1:8080/query?name=XX&age=11
```

* URI 中特定位置的字符认做传入参数：

假设路径参数定义为：/user/NAME/ACTION

127.0.0.1:8080/user/xiaoming/run 传入的参数就是 NAME=xiaoming，ACTION=run

* 在 HTTP Header 中设置的参数

* 通过 post 提交的、位于 http 请求 body 中的数据

以上参数以及其它所有的请求信息，都传入的 *gin.Context 获取。

## URI query 参数

URL 的多个 query 参数用 & 间隔，用 c.QueryXX 方法读取：

```go
//匹配：127.0.0.1:8080/query?name=xiaoming&age=11
func query(c *gin.Context) {
    name := c.DefaultQuery("name", "Guest")
    age := c.Query("age")

    c.String(http.StatusOK, "%s is %s years\n", name, age)
}
```

同名的参数被认为是数组：

```go
//匹配："127.0.0.1:8080/arr?ids=A&ids=B"
func queryArray(c *gin.Context) {
    ids := c.QueryArray("ids")
    c.JSON(http.StatusOK, gin.H{
        "ids": ids,
    })
}
```

Map 参数的传递方法：

```go
//匹配："127.0.0.1:8080/map?ids[a]=1234&ids[b]=hello"
func queryMap(c *gin.Context) {
    ids := c.QueryMap("ids")
    c.JSON(http.StatusOK, gin.H{
        "ids": ids,
    })
}
```

除了上面的参数读取方法，还可以通过 c.ShouldBindQuery 直接将参数解析到变量中：

```go
type UserInfo struct {
	Name     string            `form:"name"`
	Age      int               `form:"age"`
	Message  []string          `form:"message"`
	MoreInfo map[string]string `form:"moreinfo"`
}

func queryBind(c *gin.Context) {
	var userInfo UserInfo
	c.BindQuery(&userInfo)
	//gin 1.5 的 BindQuery 似乎不支持 map，单独获取
	userInfo.MoreInfo = c.QueryMap("moreinfo")
	c.JSON(http.StatusOK, userInfo)
}

```

## Http Header

用 c.GetHeader() 获取：

```go
func header(c *gin.Context) {
	token := c.GetHeader("TOKEN")
	c.JSON(http.StatusOK, gin.H{
		"TOKEN": token,
	})
}
```

用 c.BindHeader 直接解析到变量中：

```go
type Token struct {
	Token string `header:"token"`
}

func headerBind(c *gin.Context) {
	var token Token
	c.BindHeader(&token)
	c.JSON(http.StatusOK, token)
}
```

## URI 路径参数

路径参数需要定义路由时，在路径中进行注明，用 c.Param() 读取：

```go
func userName(c *gin.Context) {
    name := c.Param("name")
    c.String(http.StatusOK, "Hello %s\n", name)
}

func userNameAction(c *gin.Context) {
    name := c.Param("name")
    action := c.Param("action")
    c.String(http.StatusOK, "%s is %s\n", name, action)
}

func main() {
    router := gin.Default()

    // curl  127.0.0.1:8080/user/xiaoming
    // :name 必须存在
    // 匹配 /user/NAME
    // 不匹配 /user 或者 /user/
    router.GET("/user/:name", userName)

    // curl 127.0.0.1:8080/user/xiaoming/run
    // *action 是可选的
    // 匹配 /user/NAME/
    // 匹配 /user/NAME/ACTION
    // 如果 /user/NAME 没有对应的 router，重定向到 /user/NAME/
    router.GET("/user/:name/*action", userNameAction)

    // curl -X POST 127.0.0.1:8080/user/xiaoming/run
    // POST 也可以使用路径参数
    router.POST("/user/:name/*action", userNameAction)

    router.Run()
}
```

用 c.BindUri 直接解析到变量中：

```go
type UserInfo struct {
	Name   string `uri:"name"`
	Action string `uri:"action"`
}

func bindURI(c *gin.Context) {
	var userInfo UserInfo
	c.BindUri(&userInfo)
	c.JSON(http.StatusOK, userInfo)
}
```


## POST：form 表单数据

post 提交的参数位于 http 请求的 body 中，可以是任意字符，这里以 form 表单数据为例。

form 表单参数用 c.PostXX 读取，格式与 URL query 参数相同，也支持数组和 map。

```go
func postForm(c *gin.Context) {
    message := c.PostForm("message")
    name := c.DefaultPostForm("name", "guest")
    c.String(http.StatusOK, "%s %s", name, message)
}

func postFormMap(c *gin.Context) {
    ids := c.PostFormMap("ids")
    c.JSON(http.StatusOK, gin.H{
        "ids": ids,
    })
}

func postFormArray(c *gin.Context) {
    ids := c.PostFormArray("ids")
    c.JSON(http.StatusOK, gin.H{
        "ids": ids,
    })
}

func main() {
    router := gin.Default()

    // curl -XPOST 127.0.0.1:8080/form -d "name=xiaoming&message=welcome!"
    router.POST("/form", postForm)

    // curl -XPOST 127.0.0.1:8080/map -d "ids[first]=100&ids[second]=200"
    router.POST("/map", postFormMap)

    // curl -XPOST 127.0.0.1:8080/map -d "ids=100&ids=200"
    router.POST("/arr", postFormArray)

    router.Run()
}
```

## POST：json/xml/yaml

前面例子读取了 form 表单参数，在实际开发中，post 提交的参数还经常是 json、xml 格式。

Gin 内置了 json、xml 数据的解析方法，不需要额外写转换代码。Gin 可以把 form 表单、json、xml 数据直接解析到对应的变量中。

在定义变量的类型时，需要在 struct tag 中指定对应的参数名：

```go
type Login struct {
    User     string `form:"user" json:"user" xml:"user" binding:"required"`
    Password string `form:"password" json:"password" xml:"password" binding:"required" `
}
```

解析 JSON 数据：

```go
func bindXML(c *gin.Context) {
    var login Login
    if err := c.ShouldBindXML(&login); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, login)
}
```

解析 XML 数据：

```go
func bindXML(c *gin.Context) {
    var login Login
    if err := c.ShouldBindXML(&login); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, login)
}
```

支持 yaml 格式的数据，使用 c.ShouldBindYAML()。

## POST：同时支持多种格式

c.ShouldBind() 支持多种格式的数据，如果请求方法是 GET，那么它按照 form 规则解析 query 参数，如果请求方法是 POST，根据请求头中的 Content-Type 自动选择对应的方法：

```go
func bindALL(c *gin.Context) {
    var login Login
    if err := c.ShouldBind(&login); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    c.JSON(http.StatusOK, login)
}
```

Gin 支持的 Content-Type：

```go
MIMEJSON              = "application/json"
MIMEHTML              = "text/html"
MIMEXML               = "application/xml"
MIMEXML2              = "text/xml"
MIMEPlain             = "text/plain"
MIMEPOSTForm          = "application/x-www-form-urlencoded"
MIMEMultipartPOSTForm = "multipart/form-data"
MIMEPROTOBUF          = "application/x-protobuf"
MIMEMSGPACK           = "application/x-msgpack"
MIMEMSGPACK2          = "application/msgpack"
MIMEYAML              = "application/x-yaml"
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

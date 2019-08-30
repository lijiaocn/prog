# Go Template 语法

Go 语言提供了一个名为 [text/template][1] 库，这个库定义实现了 go template 语言，可以用来写 html 模板。很多用 go 语言实现的软件，譬如 docker、kubernetes 支持用 go template 定义输出的内容格式。

基本样式如下：

```go
{{ .struct成员名称 }}
```

譬如输出 docker inspect 中的指定字段：

```sh
$ docker inspect b579c6a6516b -f "{{.NetworkSettings.Networks.bridge.IPAddress}}"
172.17.0.3
```

## 参考

[1]: https://golang.org/pkg/text/template/ "Golang: Package template"

<!-- toc -->
# go module 多版本依赖功能验证

我们这里要创建的 module，它的引用方法比较特殊又比较常见——通过别名引用。

## module 初始创建

在目录 go_mod_example_pkg 中创建名为 lijiaocn.com/go/example/mod 的 module：

```sh
$ mkdir go_mod_example_pkg
$ cd go_mod_example_pkg
$ go mod init lijiaocn.com/go/example/mod
go: creating new go.mod: module lijiaocn.com/go/example/mod
```

只在 version.go 中实现一个打印版本号的函数，第一个版本是 v0.0.0：

```go
package mod

func Version() {
    println("v0.0.0")
}
```

上传到 github [introclass/go_mod_example_pkg][3]。

然后将 println("v0.0.0") 修改为 println("v1.0.0") ，发布 v1 版本：

```sh
$ git add .
$ git commit -m "release v1.0.0"
$ git push
$ git tag v1.0.0
$ git push origin v1.0.0
```

然后按照兼容 GOPATH 的方式，创建 v2 版本：

```sh
$ mkdir v2
$ cd v2
$ go mod init lijiaocn.com/go/example/mod/v2
```

在 v2 目录中重新实现 version.go：

```go
package v2

func Version() {
    println("v2.0.0")
}
```

提交代码，打标签，发布 v2.0.0：

```sh
$ git add .
$ git commit -m "release v2.0.0"
$ git push
$ git tag v2.0.0
$ git push origin v2.0.0
```

最后为了验证不使用独立主版本目录的效果，直接修改 version.go，发布 v3.0.0 版本：

```sh
$ git add .
$ git commit -m "release v3.0.0"
$ git push
$ git tag v3.0.0
$ git push origin v3.0.0
```

## module 别名设置

上面创建的 module 现在还不能通过 lijiaocn.com/go/example/mod 引用，需要进行额外设置。

引用 github 上的代码通常使用 "import github.com/xxx/xxx" 的形式，import 指令后面是 repo 路径。

但是你一定遇到这种情况，项目在 github 上，但是 import 使用的是另一个路径（别名）。
譬如上一节中的 [rsc.io/quote][8] 代码路径是 "github.com/rsc/quote"，引用时用的是 "rsc.io/quote"：

```go
import (
    "rsc.io/quote"
    quoteV3 "rsc.io/quote/v3"
)
```

这是怎样做到的？

在浏览器中打开 [https://rsc.io/quote ](https://rsc.io/quote) 不会有任何收获，要用下面的方法才能发现端倪：

```sh
$ curl  https://rsc.io/quote/v3 |grep go-import
<meta name="go-import" content="rsc.io/quote git https://github.com/rsc/quote">
```
名为 go-import 的 meta 标签的 content 中包含 git 仓库地址，这是 go get 的能力之一：从 meta 中获取 repo 地址，详情见 [Remote import paths][2]。

要通过 lijiaocn.com/go/example/mod 名称引用前面的 module，需要在站点 lijiaocn.com 中创建下面的文件：

```sh
$ mkdir -p go/example/mod
$ cat <<EOF > go/example/mod/index.html
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<meta name="go-import" content="lijiaocn.com/go/example/mod git https://github.com/introclass/go_mod_example_pkg">
</head>
<body>
<p>codes at: <a href="https://github.com/introclass/go_mod_example_pkg">https://github.com/introclass/go_mod_example_pkg</a></p>
</body>
</html>
EOF
```

## module 引用效果

前期工作准备完成，现在验证效果。

```sh
$ mkdir usemod
$ cd usemod 
$ go mod init usemod
```

代码如下：

```go
package main

import "lijiaocn.com/go/example/mod"

func main() {
    mod.Version()
}
```

不指定版本号时：

```sh
$ go get lijiaocn.com/go/example/mod
```

执行结果为 v1.0.0：

```sh
$ go run main.go 
v1.0.0
```

怀疑不指定版本号时，默认使用 v1 主版本的最新版本，按上一节的步骤加一个 v1.1.0 版本后：

```sh
$ go get lijiaocn.com/go/example/mod
go: finding lijiaocn.com/go/example/mod v1.1.0
```

果然，目标 module 中的 v2.0.0 和 v3.0.0 被直接无视，使用的是 v1 的最新版本。

尝试引用 v3.0.0 版本，结果出错，必须要有 /v3 （ **第一个结论** ）：

```sh
$ go get lijiaocn.com/go/example/mod@v3.0.0
go: finding lijiaocn.com/go/example/mod v3.0.0
go get lijiaocn.com/go/example/mod@v3.0.0: lijiaocn.com/go/example/mod@v3.0.0: invalid version: module contains a go.mod file, so major version must be compatible: should be v0 or v1, not v3
```

使用 v2 和 v3 后缀，需要为 v2 和 v3 准备一个 index.html（ **同一个 repo 不需要修改** ）：

```sh
$ mkdir go/example/mod/v3
$ cp go/example/mod/index.html go/example/mod/v2
$ cp go/example/mod/index.html go/example/mod/v3
```

同时引用 v1 和 v2：

```go
package main

import "lijiaocn.com/go/example/mod"
import "lijiaocn.com/go/example/mod/v2"

func main() {
    mod.Version()
    v2.Version()
}
```

运行结果：

```sh
$ go run main.go 
v1.1.0
v2.0.0
```

最后测试下没有独立目录的 v3 是否能引用：

```go
package main

import "lijiaocn.com/go/example/mod"
import "lijiaocn.com/go/example/mod/v2"
import "lijiaocn.com/go/example/mod/v3"

func main() {
    mod.Version()
    v2.Version()
    v3.Version()
}
```

结论是不可以，必须要有独立目录：

```sh
$ go run main.go 
go: finding lijiaocn.com/go/example/mod/v3 v3.0.0
build command-line-arguments: cannot load lijiaocn.com/go/example/mod/v3: 
    module lijiaocn.com/go/example/mod@latest (v1.1.0) found, 
    but does not contain package lijiaocn.com/go/example/mod/v3
```

上一节提出的问题答案：v1 之后的主版本都必须有独立的目录，repo 中代码冗余不可避免，至少现阶段 go 1.13 是这样的（2019-12-31 16:53:07）。

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://golang.org/cmd/go/#hdr-Remote_import_paths "Remote import paths"
[3]: https://github.com/introclass/go_mod_example_pkg.git "introclass/go_mod_example_pkg"
[8]: https://github.com/rsc/quote "rsc.io/quote"

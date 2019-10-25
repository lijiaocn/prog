<!-- toc -->
# Go 语言测试框架 GinkGo 的使用方法

学习 [ingress-nginx][2] 时，想修改它的代码并将代码提交到社区，了解 e2e 测试时，遇到了 [GinkGo][3]。

## 学习环境

这里使用的 go 版本是 go 1.13.3。

创建工作目录，安装 ginkgo：

```sh
$ go get github.com/onsi/ginkgo/ginkgo
$ go get github.com/onsi/gomega/...
$ ginkgo version
Ginkgo Version 1.10.2
```

准备一个待测的 package：

```sh
$ mkdir study-Ginkgo
$ cd study-Ginkgo
$ go mod init studyginkgo
```

在文件 target_funcs/target_funcs.go 中写几个待测的函数：

```go
package target_funcs

func ReturnTrue() bool {
    return true
}

func ReturnFalse() bool {
    return false
}

func ReturnInt(v int) int {
    return v
}
```

## ginkgo 测试代码的运行

用 ginkgo 命令生成测试模板：

```sh
$ cd target_funcs/
$ ginkgo bootstrap
Generating ginkgo test suite bootstrap for target_funcs in:
    target_funcs_suite_test.go
```

刚生成的 target_funcs_suite_test.go 中现在还没有任何测试代码，运行方法：

方法1，用 ginkgo：

```sh
$ ginkgo
Running Suite: TargetFuncs Suite
================================
Random Seed: 1571986734
Will run 0 of 0 specs


Ran 0 of 0 Specs in 0.001 seconds
SUCCESS! -- 0 Passed | 0 Failed | 0 Pending | 0 Skipped
PASS

Ginkgo ran 1 suite in 5.353367082s
Test Suite Passed
```

方法2，用 go test：

```sh
go test
Running Suite: TargetFuncs Suite
================================
Random Seed: 1571986747
Will run 0 of 0 specs


Ran 0 of 0 Specs in 0.000 seconds
SUCCESS! -- 0 Passed | 0 Failed | 0 Pending | 0 Skipped
PASS
ok      studyginkgo/target_funcs    0.017s
```

方法3，生成二进制文件，ginkgo 可以测试代码编译到一个二进制文件中：

```sh
$ ginkgo build
Compiling target_funcs...
    compiled target_funcs.test
```

生成的二进制文件 target_funcs.test 可以直接运行：

```sh
./target_funcs.test
Running Suite: TargetFuncs Suite
================================
Random Seed: 1571986954
Will run 0 of 0 specs


Ran 0 of 0 Specs in 0.000 seconds
SUCCESS! -- 0 Passed | 0 Failed | 0 Pending | 0 Skipped
PASS
```

## ginkgo 测试代码的编写

为 target_funcs_suite_test.go 生成对应的测试代码文件：

```sh
$ ginkgo generate target_funcs
```

上面的命令生成测试 target_funcs_test.go。如果不在 $GOPATH 目录下，可能会遇到下面的错误，ginkgo 大概还没有支持 gomod（2019-10-25 15:23:23）。这个错误不影响使用，将 target_funcs_test.go 中的 UNKNOWN_PACKAGE_PATH 修改成所在的 package 就可以了。

```
Couldn't identify package import path.

    ginkgo generate

Must be run within a package directory under $GOPATH/src/...
You're going to have to change UNKNOWN_PACKAGE_PATH in the generated file...

Generating ginkgo test for TargetFuncs in:
  target_funcs_test.go
```

target_funcs_test.go 内容如下，在 Describe 中添加测试函数：

```go
package target_funcs_test

import (
    . "github.com/onsi/ginkgo"
    . "github.com/onsi/gomega"

    . "studyginkgo/target_funcs"
)

var _ = Describe("TargetFuncs", func() {

})
```

## ginkgo 提供的 block

ginkgo 提供了多个类型的 block（函数），上面的 Describe() 就是一个 block。

在 XX_suite_test.go （这里是 target_funcs_suite_test.go）中使用的 block：

```sh
BeforeSuite()          :在整个测试开始之前执行的操作
AfterSuite()           :在整个测试完成之后执行的操作
```

在 XX_test.go（这里是 target_funcs_test.go）中使用的 block：

```sh
BeforeEach()           :每个测试用例运行前执行的操作，位于 Describe 中，可以有多个
JustBeforeEach()       :和BeforeEach()类似，在所有的 BeforeEach()之后和It()之前执行
AfterEach()            :每个测试用例运行后执行的操作
JustAfterEach()        :紧跟在It()之后执行

Describe()             :最顶层的测试用例包裹容器，同一目标的测试用例，可以嵌套
Context()              :比 Describe 低一级的测试用例包裹容器，同一个条件下的测试用例
It()                   :单个测试用例，位于 Describe 或者 Context 中
Specify()              :It()的别名，用途和 It() 完全相同
```

专用于性能测试的 block，使用范围和 It() 相同：

```sh
Measure()              :用于性能测试的 block()
```

Describe、Context、It 和 Measure 支持 P 和 X 前缀，带有 P 或 X 前缀的这几个 block 不参与测试。

Describe、Context 和 It 支持 F 前缀，如果有带有 F 前缀的这些 block，测试时只会运行这些 block 中的测试用例。

## 测试示例

target_funcs_suite_test.go 内容如下：


```go
package target_funcs_test

import (
    "testing"

    . "github.com/onsi/ginkgo"
    . "github.com/onsi/gomega"
)

func TestTargetFuncs(t *testing.T) {
    RegisterFailHandler(Fail)
    RunSpecs(t, "TargetFuncs Suite")
}

var _ = BeforeSuite(func() {
    println("BeforeSuite")
})

var _ = AfterSuite(func() {
    println("AfterSuite")
})
```

target_funcs_test.go 的内容如下：

```go
package target_funcs_test

import (
    . "github.com/onsi/ginkgo"
    . "github.com/onsi/gomega"

    . "studyginkgo/target_funcs"
)

var _ = Describe("TargetFuncs", func() {

    BeforeEach(func() {
        println("BeforeEach-2")
    })

    BeforeEach(func() {
        println("BeforeEach-1")
    })

    JustBeforeEach(func() {
        println("JustBeforeEach-1")
    })

    JustBeforeEach(func() {
        println("JustBeforeEach-2")
    })

    JustAfterEach(func() {
        println("JustAfterEach-1")
    })

    JustAfterEach(func() {
        println("JustAfterEach-2")
    })

    AfterEach(func() {
        println("AfterEach-1")
    })

    AfterEach(func() {
        println("AfterEach-2")
    })

    Describe("ReturnInt", func() {
        Context("default", func() {

            var (
                input  int
                result int
            )

            BeforeEach(func() {
                println("BeforeEach in Context")
                input = 1
                result = 1
            })

            AfterEach(func() {
                println("AfterEach in Context")
                input = 0
                result = 0
            })

            It("return value", func() {
                println("Exec Test Case")
                v := ReturnInt(input)
                Expect(v).To(Equal(result))
            })
        })
    })
})
```

执行结果：

```sh
$ go test
Running Suite: TargetFuncs Suite
================================
Random Seed: 1571998428
Will run 1 of 1 specs

BeforeSuite
BeforeEach-2
BeforeEach-1
BeforeEach in Context
JustBeforeEach-1
JustBeforeEach-2
Exec Test Case
JustAfterEach-1
JustAfterEach-2
AfterEach in Context
AfterEach-1
AfterEach-2
•AfterSuite

Ran 1 of 1 Specs in 0.000 seconds
SUCCESS! -- 1 Passed | 0 Failed | 0 Pending | 0 Skipped
PASS
ok      studyginkgo/target_funcs    0.018s
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://www.lijiaocn.com/soft/k8s/ingress-nginx/ "ingress-nginx 的使用方法"
[3]: http://onsi.github.io/ginkgo/ "ginkgo"

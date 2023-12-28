<!-- toc -->
# 测试用例的覆盖率

Go 语言在设计的时候就考虑到工程实践，融入了注释文档、单元测试和基准测试等软件工程中的技术，上一节提到的代码组织方法也是软件工程思想的体现。在语言层面统一工具和方法，极大地提高了协作效率。

单元测试是工作代码之外最重要的内容， Go 语言天生支持。测试用例的写法只要看几个例子就学会了，譬如下面这个最简单函数功能测试。

**目标文件 funcs.go：**

```go
package testcase

func SumSlice(nums []int) int {
    sum := 0
    for _,v := range nums{
        sum=sum+v
    }
    return sum
}

func SumArray(nums [10]int) int{
    sum := 0
    for _,v := range nums{
        sum=sum+v
    }
    return sum
}
```

**测试用例 funcs_test.go：**

```go
package testcase

import (
    "testing"
)

func TestSumSlice(t *testing.T) {
    arrays := []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    expect := 45
    sum := SumSlice(arrays[:])
    if sum != expect {
        t.Errorf("result is %d (should be %d)", sum, expect)
    }
}
```

然后重点来了，执行 go test 只会告知测试是否通过：

```go
$ go test       
PASS
ok      go-code-example/testcase        0.806s
```

强大的是 -cover，可以告知测试覆盖率：

```go
$ go test -cover
PASS
coverage: 50.0% of statements
ok      go-code-example/testcase        0.306s
```

上面的测试用例覆盖率只有 50%，用下面的方法查看没有覆盖的代码：

```go
$ go test -coverprofile=coverage.out 
$ go tool cover -html=coverage.out  
```

![测试覆盖情况](../img/cover.png)

测试覆盖率的详细说明见 [The cover story][2]。

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://blog.golang.org/cover "The cover story"

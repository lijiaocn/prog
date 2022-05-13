<!-- toc -->
# Go 语言按值传递的开销很大

Go 语言所有的参数都是按值传递，Go 语言中所有的变量都是值，特别是数组也是值。

## 数组也按值传递

如果把一个数组作为参数，那么这个数组会被完整的拷贝一份，执行效率会严重降低。

以前面用到的 funcs.go 为例：

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

写两个基准测试函数：

```go
package testcase

import (
    "testing"
)

func TestSumSlice(t *testing.T) {
    arrays := [10]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    expect := 45
    sum := SumSlice(arrays[:])
    if sum != expect {
        t.Errorf("result is %d (should be %d)", sum, expect)
    }
}

func BenchmarkSumSlice(b *testing.B) {
    arrays := [10]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    s := arrays[:]
    for i := 0; i < b.N; i++ {
        SumSlice(s)
    }
}

func BenchmarkSumArray(b *testing.B) {
    arrays := [10]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    for i := 0; i < b.N; i++ {
        SumArray(arrays)
    }
}
```

基准测试结果如下结果如下：

```sh
goos: darwin
goarch: amd64
pkg: go-code-example/testcase
BenchmarkSumSlice-4   	161025976	         6.67 ns/op
BenchmarkSumArray-4   	90106534	        13.9 ns/op
```

可以看到在数组长度只有 10 的情况下， SumSlice 和 SumArray 的执行效率就已经相差悬殊。

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

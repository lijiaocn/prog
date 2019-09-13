<!-- toc -->
# Go 语言的类型转换


## string 转换成 []byte

```go
var str string
str = "abcd"
var [] bytes

bytes = []byte(str)
```

## string 转数值 
标准库 [strconv][1] 提供了多个 string 与数值的转换方法：

```go
i, err := strconv.Atoi("-42")
s := strconv.Itoa(-42)
```

指定进制：

```go
b, err := strconv.ParseBool("true")
f, err := strconv.ParseFloat("3.1415", 64)
i, err := strconv.ParseInt("-42", 10, 64)
u, err := strconv.ParseUint("42", 10, 64)
```

## 数值转字符串

```go
s := strconv.Itoa(-42)
s = fmt.Sprintf("%d", 32)
```

[1]: https://golang.org/pkg/strconv/#pkg-index "Package strconv"

<!-- toc -->
# 有大量反序列化时，目标 Struct 的成员用指针

[JSON and Go][2] 中介绍反序列化时说，介绍了目标 struct 中有 Reference Type 类型成员时的处理：

```go
type FamilyMember struct {
    Name    string
    Age     int
    Parents []string
}

var m FamilyMember
err := json.Unmarshal(b, &m)
```

FamilyMember 的 Parents 是一个 Slice，在反序列化时候，会为它分配空间。

重点是，如果目标字符串中没有 Parents，那么 Parents 是 nil。据此判断，反序列化的目标 struct 中应当尽可能的使用 Reference Type，在有缺失字段时，这种方式更高效且节省内存。

## 两种定义方式

Obj 定义了长度为 100 的数组，ObjP 使用的是 Slice：

```go
package unmarshal

import "encoding/json"

type Obj struct {
    Value int
    Array [100]int
}

type ObjP struct {
    Value int
    Array []int
}

func UnmarshalObj(str []byte, v interface{}) {
    json.Unmarshal(str, v)
}

func UnmarshalObjP(str []byte, v interface{}) {
    json.Unmarshal(str, v)
}
```

## 基准测试结果

基准测试代码如下，模拟实际场景，每次反序列化都用一个新的变量，设计了 Array 有和无两种场景：

```go
package unmarshal

import (
    "testing"
)

var objstr_noarray = []byte(`{"Value":10}`)
var objstr_array = []byte(`{"Value":10, "Array":[1,2,3,4,5,7,8]}`)

func BenchmarkUnmarshalObjNoArray(b *testing.B) {
    for i := 0; i < b.N; i++ {
        obj := &Obj{}
        UnmarshalObj(objstr_noarray, obj)
    }
}

func BenchmarkUnmarshalObjPNoArray(b *testing.B) {
    for i := 0; i < b.N; i++ {
        obj := &ObjP{}
        UnmarshalObjP(objstr_noarray, obj)
    }
}

func BenchmarkUnmarshalObjArray(b *testing.B) {
    for i := 0; i < b.N; i++ {
        obj := &Obj{}
        UnmarshalObj(objstr_array, obj)
    }
}

func BenchmarkUnmarshalObjPArray(b *testing.B) {
    for i := 0; i < b.N; i++ {
        obj := &ObjP{}
        UnmarshalObjP(objstr_array, obj)
    }
}
```

基准测试结果显示，执行效率的差距非常明显：

```sh
goos: darwin
goarch: amd64
pkg: go-code-example/unmarshal
BenchmarkUnmarshalObjNoArray-4    	 1385480	       861 ns/op
BenchmarkUnmarshalObjPNoArray-4   	 1712936	       693 ns/op
BenchmarkUnmarshalObjArray-4      	  229220	      4899 ns/op
BenchmarkUnmarshalObjPArray-4     	  367184	      2883 ns/op
PASS
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2019/12/23/go-blog-10-years.html#%E5%B8%B8%E8%A7%84%E7%BB%86%E8%8A%82 "json 序列化和反序列化"

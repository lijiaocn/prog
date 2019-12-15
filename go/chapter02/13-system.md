<!-- toc -->
# 操作系统相关

## unsafe 

	package unsafe

	type ArbitraryType int  // shorthand for an arbitrary Go type; it is not a real type
	type Pointer *ArbitraryType

	func Alignof(variable ArbitraryType) uintptr
	func Offsetof(selector ArbitraryType) uintptr
	func Sizeof(variable ArbitraryType) uintptr

## Size and alignment guarantees 

	type                                 size in bytes
	
	byte, uint8, int8                     1
	uint16, int16                         2
	uint32, int32, float32                4
	uint64, int64, float64, complex64     8


## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

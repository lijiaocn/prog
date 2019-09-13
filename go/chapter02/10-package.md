<!-- toc -->
# go的包管理语句

## 声明包

	PckageClause  = "package" PackageName .
	PackageName    = identifier .

## 导入包(Import declarations )

	ImportDecl       = "import" ( ImportSpec | "(" { ImportSpec ";" } ")" ) .
	ImportSpec       = [ "." | PackageName ] ImportPath .
	ImportPath       = string_lit .

例如：

	Import declaration          Local name of Sin
	
	import   "lib/math"         math.Sin
	import m "lib/math"         m.Sin
	import . "lib/math"         Sin
	import _ "lib/math"


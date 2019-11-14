<!-- toc -->
# Bash 的变量与数据结构

主要学习资料： [bash - GNU Bourne-Again SHell][2]。

## 编程常用操作

### 用 read 实现多变量赋值

用下面的命令可以同时定义多个变量，并赋值：

```sh
read a b c <<< "1 2 3";echo "$a|$b|$c"
```

参考：[Linux bash：多个变量赋值](https://codeday.me/bug/20170709/39537.html)

### 读取命令行参数

#### 内置命令 getopts

用 getopts 解析命令行参数，getopts 不支持长格式，只能用 `-h` 这样的短格式：

```sh
while getopts "p:h:" option ;do
    if [[ $option == "p" ]];then
        echo "listener port: $OPTARG"
    fi
    if [[ $option == "h" ]];then
        read name value <<< "${OPTARG//:/ }";
        headers="$headers\nproxy_set_header $name $value;"
    fi
done

echo $headers
```

执行效果如下：

```sh
$ ./getopts.sh -p 80 -h h1:v1 -h h2:v2
listener port: 80

proxy_set_header h1 v1;
proxy_set_header h2 v2;
```

## 变量值读取

Bash 的变量值读取支持很多扩展方式（Parameter Expansion）。

### 未定义变量

针对变量是否定义，存在以下几种处理方法：

```sh
${parameter:-word}:  如果变量没有定义或者 null，返回默认值 word
${parameter:=word}:  如果变量没有定义或者 null，为变量赋值 word，并返回 word
${parameter:?word}:  如果变量没有定义或者 null，在错误输出中显示 word
${parameter:+word}:  如果定义变量，注意是是定义了！用 word 替代（返回 word）
```

示例：

```sh
echo "未定义的变量，使用默认值：${notdef1:-word}  $notdef1"
echo "未定义的变量，赋值默认值：${notdef2:=word}  $notdef2"
echo "已定义的变量，使用替代数值：${notdef2:+valueinstead}"
echo "未定义的变量，打印错误信息：${notdef3:?notdef}"
```

执行结果为：

```sh
未定义的变量，使用默认值：word
未定义的变量，赋值默认值：word  word
已定义的变量，使用替代数值：valueinstead
./variable.sh: line 13: notdef3: notdef
```

### 字符串处理

如果变量的值是字符串，在读取时可以直接进行处理。

下面的用法对非字符串变量也可以使用，譬如`@`和`*`，譬如数组，操作含义也相应变化，变量为字符串时，这些操作的含义是最好理解的：

```sh
${parameter:offset}         :第一个字符以后的字符，不包括第一个
${parameter:offset:length}  :第一个字符以后的两个字符，不包括第一个

 :如果变量是 @，显示从 offset 开始的 length 个命令行参数
 :如果变量是 Array[@] 或 Array[*] ，显示从 offset 开始的 length 个数组成员

${#parameter}               :字符串长度

 :如果变量是 @ 或 *，返回命令行参数个数
 :如果变量是 Array[@] 或 Array[*]，返回数组的成员数量

${parameter#word}           :从字符串头开始，去掉 word 匹配的部分，最短匹配
${parameter##word}          :从字符串头开始，去掉 word 匹配的部分，最长匹配
${parameter%word}           :从字符串尾开始，去掉 word 匹配的部分，最短匹配
${parameter%%word}          :从字符串尾开始，去掉 word 匹配的部分，最长匹配
${parameter/pattern/string} :字符后换，默认只替换第一个
                             pattern 以 "/" 开头，全替换
                             pattern 以 "#" 开头，从首字母开始匹配
                             pattern 以 "%" 开头，从尾字母开始匹配

 :如果变量是 @ 或 *，对所有命令行参数进行处理，返回处理后的列表
 :如果变量是 Array[@] 或 Array[*]，对数组所有成员进行处理，返回处理后的列表
```

示例：

```sh
str="abcddeddfghijka"

echo "第0个字符后: ${str:0}"
echo "第1个字符后: ${str:1}"
echo "第1个字符后的两个字符: ${str:1:2}"

echo "字符串长度：${#str}"

echo "head match #abc: ${str#abc}"
echo "head match ##abc: ${str##abc}"

echo "head match #abc*: ${str#abc*}"
echo "head match ##abc*: ${str##abc*}"

echo "tail match %ijk: ${str%ijk}"
echo "tail match %%ijk: ${str%%ijk}"

echo "tail match %*ijk: ${str%*ijk}"
echo "tail match %%*ijk: ${str%%*ijk}"

echo "replace /d/D（替换一个）: ${str/d/D}"
echo "replace //d/D（全部替换）: ${str//d/D}"
echo "replace /#a/A（从开始处匹配替换）: ${str/#a/A}"
echo "replace /%a/A（从结尾处匹配替换）: ${str/%a/A}"
```

执行结果为：

```sh
第0个字符后: abcddeddfghijka
第1个字符后: bcddeddfghijka
第1个字符后的两个字符: bc
字符串长度：15
head match #abc: ddeddfghijka
head match ##abc: ddeddfghijka
head match #abc*: ddeddfghijka
head match ##abc*:
tail match %ijk: abcddeddfghijka
tail match %%ijk: abcddeddfghijka
tail match %*ijk: abcddeddfghijka
tail match %%*ijk: abcddeddfghijka
replace /d/D（替换一个）: abcDdeddfghijka
replace //d/D（全部替换）: abcDDeDDfghijka
replace /#a/A（从开始处匹配替换）: Abcddeddfghijka
replace /%a/A（从结尾处匹配替换）: abcddeddfghijkA
```

### 读取变量名

注意读取的是变量的名字，不是变量值，

```sh
${!prefix*}，${!prefix@}: 返回以 prefix 为前缀的已经定义的变量名
```

示例：

```sh
prefixV1="a"
prefixV2="b"
prefixV3="c"

echo ${!prefix*}
echo ${!prefix@}
```

执行结果为：

```sh
prefixV1 prefixV2 prefixV3
prefixV1 prefixV2 prefixV3
```

### 读取数组信息

见数组章节。

```sh
${!name[@]}，${!name[*]}：读取数组的 key 值
```

## 数组

使用下面的形式赋予值时，会自动创建数组变量：

```sh
array["0"]="value0"
array["1"]="value1"
array["2"]="value2"
array["5"]="value5"
```

如果要声明一个数组类型的变量，用 declare -a 声明：

```sh
# 声明数组变量 array
declare -a array
```

用下面的方式生成一个带有值数组变量：

```sh
array=("value0" "value1" "value2" "value3")
```

读取数组中指定位置的值：

```sh
echo ${array[1]}
```

读取数组的信息：

```sh
# 打印数组中的所有值
for i in ${array[@]}
do
    echo "data: $i"
done

# 打印数组中有值的 index
for i in ${!array[@]}
do
    echo "index: $i"
done

# 打印数组内元素个数
echo "array size: ${#array[@]}"
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: http://man7.org/linux/man-pages/man1/bash.1.html  "bash - GNU Bourne-Again SHell"


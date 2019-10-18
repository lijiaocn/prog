<!-- toc -->
# Shell 的基本数据结构 —— 数组

```sh
# 声明数组变量 array
declare -a array

# 为数组赋值
array["0"]="value0"
array["1"]="value1"
array["2"]="value2"
array["5"]="value5"

# 打印数组中的所有值
for i in ${array[@]}
do
    echo "data $i"
done

# 打印数组中有值的 index
for i in ${!array[@]}
do
    echo "index $i"
done

# 打印数组内元素个数
echo "array size: ${#array[@]}"
```

## 参考

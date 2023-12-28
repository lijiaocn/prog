<!-- toc -->
# 常用的 Bash 内置的命令

Bash 有很多内置命令，譬如 `:`、`.`、`source`、`alias`、`bg` 等。

## trap

设置信号处理函数，信号发生后，触发函数的执行。

除了支持 `man signal` 中列出的 32 个系统信号，还支持 DEBUG、ERR、EXIT，分别在每个命令执行前后触发、出错时触发、退出时触发。

```sh
function debug {
   echo "DEBUG"
}
trap debug DEBUG

function err {
   echo "ERR"
}
trap err ERR

function cleanup {
   echo "EXIT"
}
trap cleanup EXIT

echo "exec command..."
ls /noexit
```

执行结果如下：

```sh
DEBUG
DEBUG
DEBUG
exec command...
DEBUG
ls: /noexit: No such file or directory
DEBUG
ERR
DEBUG
EXIT
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

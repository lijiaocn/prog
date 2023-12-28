# Python3 的命令行参数读取

命令行参数从 sys.argv[] 中读取，sys.argv[0] 是文件名，sys.arg[1] 是第一个命令行参数，以此类推：

```python
import sys

if __name__ == "__main__":
    print("%d %s %s" % (sys.argv.__len__(), sys.argv[0], sys.argv[1]))
```

* 如果文件名是 `-` （标注输入），sys.argv[0] 是 `-`；
* 如果使用了 -c 参数，sys.argv[0] 是 -c；
* 如果使用了 -m 参数，sys.argv[0] 是 -m 指定的 module 的完整名称



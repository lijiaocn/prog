<!-- toc -->
# Pyhont3 的运行环境与依赖管理

## virtualenv

用 virtualenv 创建独立的 python 运行环境是一个非常好的做法，不干扰本地的 python 环境也不受本地 python 环境影响。

安装 virutalenv：

```sh
pip install virtualenv
```

创建 python 运行环境：

```sh
virtualenv -p python3 env  # 创建一个名为env的目录，存放python文件
                           # -p 指定 python 的版本
```

进入独立的 python 环境：

```sh
source bin/activate
```

这时在当前 shell 窗口用 pip 安装的 python 包都被存放在 env 目录中，完全不影响本地的 python 环境。

退出时，输入下面的命令即可：

```sh
deactivate
```

## 依赖包管理

依赖包记录到 requirements.txt 文件中。

导出当前项目依赖的 python 包：

```sh
pip freeze > requirements.txt
```

安装依赖的 python 包：

```sh
pip install -r requirements.txt
```

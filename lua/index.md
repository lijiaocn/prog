<!-- toc -->
# Lua编程速查手册（常用操作)

这里记录一些常用的lua操作，在长时间不编程后，可能会忘记很多基本的操作，这一章节的内容用于帮助快速回忆起这些基本的操作，从手冷快速热身到手热。

[Lua Programming Gems](https://www.lua.org/gems/)中收集了一些Lua编程文章，例如[Lua Performance Tips](https://www.lua.org/gems/sample.pdf)

以往的笔记对 lua 的安装、代码管理等有比较详细的记录：

* [编程语言Lua（一）：入门介绍、学习资料、项目管理与调试方法](https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2018/10/22/language-lua-study.html)
* [编程语言Lua（二）：基本语法学习](https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2018/10/28/language-lua-02-syntax.html)
* [编程语言Lua（三）：Lua的语法细节](https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2018/11/02/language-lua-03-systax-detail.html)
* [使用Lua编程时需要注意的一些影响性能的操作](https://www.lijiaocn.com/%E7%BC%96%E7%A8%8B/2018/12/10/lua-programm-performance-tip.html)

## 环境准备

安装 Lua，可以用下面命令安装：

```sh
$ brew install lua        # for mac
$ yum  install -y lua     # for centos
```

或者编译安装：

```sh
$ curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
$ tar zxf lua-5.3.5.tar.gz
$ cd lua-5.3.5
$ make linux test    # for linux
$ make macosx test   # for mac
```

## lua 代码的运行

在命令行交互式运行：

```sh
$ lua
Lua 5.3.5  Copyright (C) 1994-2018 Lua.org, PUC-Rio
> print("hello world!")
hello world!
>
```

运行 lua 代码文件：

```lua
#! /usr/bin/env lua
--
-- 01-hello-world.lua
-- Copyright (C) 2018 lijiaocn <lijiaocn@foxmail.com>
--
-- Distributed under terms of the GPL license.

print("Hello World 1!")
```

```sh
$ lua 01-hello-world.lua
Hello World 1!
```

## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"

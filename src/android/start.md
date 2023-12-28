<!-- toc -->
# 简单了解一下 android 应用的开发过程

## 项目结构

用 Intelli Idea 或者 Android Studio 创建一个 andorid 项目。

项目的主要代码位于 app/src/main 目录中：

```sh
$ tree -L 2 android-quickstart/app/src/main
android-quickstart/app/src/main
├── AndroidManifest.xml   # 应用的特性配置
├── java
├   └── com
├       └── example
├           └── android_quickstart
├               ├── MainActivity.java  # 应用入口
├               └── ui
└── res
    ├── drawable
    ├── drawable-v24
    ├── layout              # activity 的 UI
    ├── menu
    ├── mipmap-anydpi-v26
    ├── mipmap-hdpi
    ├── mipmap-mdpi
    ├── mipmap-xhdpi
    ├── mipmap-xxhdpi
    ├── mipmap-xxxhdpi
    ├── navigation
    └── values
```

## apk 文件

安卓应用的代码、数据和资源文件一起大包成 apk 文件发布，安卓应用在安全沙盒中运行：

* 每个 app 默认使用一个独立的 linux 用户，实现文件的隔离
* 进程在隔离的 vm 中运行
* 使用同一个证书签署的 app 可以共用用户、vm，从而可以访问彼此的文件
* app 可以申请设备的访问权限

## app 的组成

**Activities**: 

* 每个交互界面对应一个 Activity
* 其它 app 可以唤起另一个 app 允许的 activity
* 父类：Activity

**Services**:

* 后台运行的服务
* activity 等组件可以启动、绑定 service
* service 分为用户可感知（后台音乐）和用户无感知（服务调用）两种类型
* 父类：Service

**Broadcast receivers**:

* 跨 app 的事件广播
* 事件是一个 Intent，BroadcastReceiver 的子类接收并响应事件

**Content providers**:

* 写入文件系统的持久数据，其它 app 可以操作另一个 app 允许的数据
* 父类：ContentProvider


以上组件通过 Intent 交互。

在 AndroidManifest.xml 中声明所有的组件，以及声明需要的权限。




## 参考

1. [李佶澳的博客][1]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://developer.android.com/training/basics/firstapp "Build your first app"

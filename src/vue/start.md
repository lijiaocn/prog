<!-- toc -->
# vue 学习资料

官网教程： https://cn.vuejs.org/v2/guide/

创建项目的脚手架工具vue-cli： https://cli.vuejs.org/zh/guide/

入门视频课程：https://www.imooc.com/learn/980

## vue 开发环境

IDE 使用 Intelli Idea，在 Preference -> Plugins -> Marketplace 中搜索插件 "vue.js"，安装。

在 Preference -> Editor -> File Types -> HTML 中，添加新的文件后缀 "*.vue"。

在 Preference -> Languages & Frameworks -> JavaScript，选择 ECMAScript6

在 Preference -> Editor -> File and Code Templates 中，创建一个 vue 模版：

```html
<template>

    <div> {{msg}}</div>

</template>

<style></style>

<script>

    export default{ data () { return {msg: 'vue模板页'} } }

</script>
```

新建 vue 项目：Static Web -> Vue.js

## vue-cli

[vue-cli][3] 是搭建 vue 项目的脚手架。

安装、验证：

```sh
$ npm install -g @vue/cli
$ npm --version
 vue --version
@vue/cli 4.1.2
```

创建项目:

```sh
$ vue create hello-world
```

构建：

```sh
$ cd hello-world
$ npm run serve
$ npm run lint
$ npm run build 
```

项目结构：

```sh
$ tree -L 2 
public
├── favicon.ico
└── index.html     //入口
src
├── App.vue        //app
├── assets         //资源文件
│   └── logo.png
├── components     //vue 组件
│   └── HelloWorld.vue
└── main.js
```

## 参考

1. [李佶澳的博客][1]
2. [Intellij IDEA搭建vue-cli项目][2]
3. [vue-cli][3]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://www.cnblogs.com/wyq-web/p/9639274.html "Intellij IDEA搭建vue-cli项目"
[3]: https://cli.vuejs.org/zh/guide/ "vue-cli"

# 在Django页面模版中引入静态资源

Django默认到应用的static子目录中查找静态资源。

	mkdir polls/static

## 创建一个静态的css文件

创建一个css文件，polls/static/polls/style.css：

```css
li a {
    color: green;
}
```

在页面模版中用load命令引用：

```django
{% load static %}

<link rel="stylesheet" type="text/css" href="{% static 'polls/style.css' %}">
```

需要注意的是，这时候要重启Django server，否则会找不到静态文件：

```sh
python manage.py runserver
```

## 引用静态图片

引用其它静态文件时用的都是相对当前文件所在目录的路径，例如对于polls/static/polls/images/backgroud.gif，在polls/static/polls/style.css中引用时，用的路径是:images/background.gif。

```css
body {
    background: white url("images/background.gif") no-repeat;
}
```

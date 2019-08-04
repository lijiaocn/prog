# 第一个Django应用

前面创建了一个Django项目，接下来在项目中创建Django应用。

## 创建一个名为poll的应用

在Django项目目录中运行下面的命令：

	python manage.py startapp polls

自动生成的polls应用代码如下：

```sh
(env) lijiaos-mbp:mysite lijiao$ tree polls/
polls/
├── __init__.py
├── admin.py
├── apps.py
├── migrations
│   └── __init__.py
├── models.py
├── tests.py
└── views.py

1 directory, 7 files
```

## 开发应用的视图

`views.py`中是应用的视图（views)，视图是与url一一对应的。

例如在views.py中添加一个名为index的视图，它的传入参数就是用户的请求：

```python
from django.shortcuts import render

# Create your views here.

from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, world. You're at the polls index.")
```

request的类型是[HttpRequest](https://docs.djangoproject.com/en/2.2/ref/request-response/)。

需要创建`polls/urls.py`文件，并在其中添加下面的内容：

```python
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
```

最后在django项目文件`mysite/urls.py`中设置polls应用的url：

```python
from django.contrib import admin
from django.urls import include, path

urlpatterns = [
    path('polls/', include('polls.urls')),
    path('admin/', admin.site.urls),
]
```

上面设置的含义是`/polls/XX`样式的请求被转发给polls应用处理，在polls/urls.py中找到对应的处理函数，也就是view。

path函数的定义：[path(route, view, kwargs=None, name=None)](https://docs.djangoproject.com/en/2.2/ref/urls/#django.urls.path)

## 访问应用视图

用python ./manage.py runserver 启动项目后，访问polls应用的视图`/polls/`：

```sh
$ curl http://127.0.0.1:8000/polls/
Hello, world. You're at the polls index.
```

现在应用polls之后一个视图，如果使用其它的url会返回404，即页面没找到的错误：

```
Page not found (404)
Request Method:	GET
Request URL:	http://127.0.0.1:8000/polls/ab
Using the URLconf defined in mysite.urls, Django tried these URL patterns, in this order:

admin/
polls/ [name='index']
The current path, polls/ab, didn't match any of these.

You're seeing this error because you have DEBUG = True in your Django settings file. Change that to False, and Django will display a standard 404 page.
```

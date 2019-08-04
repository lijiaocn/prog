# 第一个Django项目

[Writing your first Django app, part 1](https://docs.djangoproject.com/en/2.2/intro/tutorial01/)

## Django项目的创建与目录结构

创建项目，注意项目名称不能是django和test，避免引发命名冲突:

	django-admin startproject mysite

自动生成的项目文件：

```sh
(env) lijiaos-mbp:django-py3 lijiao$ tree mysite/
mysite/
├── manage.py
└── mysite
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    └── wsgi.py

1 directory, 5 files
```

[manage.py](https://docs.djangoproject.com/en/2.2/ref/django-admin/)是用来管理django项目的命令。

`mysite/mysite`：项目的代码目录，它是一个标准的python package。

`__init__.py`：一个空文件，表示所在目录为python package，[python package说明](https://docs.python.org/3/tutorial/modules.html#tut-packages)。

`settings.py`：Django项目的配置文件, [Django settings](https://docs.djangoproject.com/en/2.2/topics/settings/)。

`urls.py`：Django项目的url声明，[URL dispatcher](https://docs.djangoproject.com/en/2.2/topics/http/urls/)。

`wsgi.py`：面向使用WSGI的web server的入口，[How to deploy with WSGI](https://docs.djangoproject.com/en/2.2/howto/deployment/wsgi/)。

## 启动开发模式下的Django Server

开发模式下，可以用下面的方法启动Django Server：

	cd mysite
	python ./manage.py runserver 0:8080

这种方式启动的server会自动加载最新的代码，代码变更后不需要重新启动。


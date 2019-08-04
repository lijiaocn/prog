# Django对接数据库

[settings.py](https://docs.djangoproject.com/en/2.2/ref/settings/)是项目的配置文件，其中包含数据库相关的配置。

## 配置项目的数据库

项目的数据库在项目目录中的settings.py中设置，数据库相关的[配置样式](https://docs.djangoproject.com/en/2.2/ref/settings/#databases)如下：

```python
# Database
# https://docs.djangoproject.com/en/2.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

`ENGINE`是数据库类型，Django支持以下四种数据库：

	'django.db.backends.postgresql'
	'django.db.backends.mysql'
	'django.db.backends.sqlite3'
	'django.db.backends.oracle'

默认使用sqlite，这是一个文件数据库，只需要在`NAME`参数指定数据库文件，如果用其它类型的数据库还需要指定`NAME`、`USER`、`PASSWORD`等参数，例如：

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'mydatabase',
        'USER': 'mydatabaseuser',
        'PASSWORD': 'mypassword',
        'HOST': '127.0.0.1',
        'PORT': '5432',
    }
}
```

数据库需要提前部署创建，根据自己的实际情况选择合适的数据库。只需要创建数据库不需要创建表，数据库表在下一节中用Django代码定义，并自动完成创建。

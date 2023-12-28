<!-- toc -->
# Django创建站点管理后台

Django提供了[后台管理模版](https://docs.djangoproject.com/en/2.2/intro/tutorial02/#creating-an-admin-user)，可以直接创建网站后台，减少开发工作.

## 创建管理员账号

在前面设置第一个应用polls的时候，应该注意到项目目录的urls.py中是有一个admin/路径的，访问该路径时（`http://127.0.0.1:8000/admin/`），会看到一个`Django administration`的登录页面。

还没有管理员账号的时候需要用manager.py创建一个：

```sh
python manage.py createsuperuser
```

设置过程如下：

```sh
(env) 192:mysite lijiao$ python manage.py createsuperuser
Username (leave blank to use 'lijiao'): admin
Email address: admin@example.com
Password:   # 这里输入密码
Password (again):
This password is too short. It must contain at least 8 characters.
This password is too common.
This password is entirely numeric.
Bypass password validation and create user anyway? [y/N]: y
Superuser created successfully.
```

然后就可以用新创建的用户名和密码登录Django后台了。

## 在后台中添加应用页面

Django的后台其实就是一个数据库网页，可以在里面直接操作数据库中的数据，默认情况下里面只有了Groups和Users的数据，应用的数据不在其中。

如果要在Django后台中管理应用，需要在应用的admin.py中注册对应的Model，例如在polls/admin.py中注册Question：

```python
from django.contrib import admin

# Register your models here.

from .models import Question

admin.site.register(Question)
```

代码添加之后，刷新后台就会看到多出了一个Question页面，可以查看编辑里面的数据。

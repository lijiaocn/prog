<!-- toc -->
# Django数据库初始化

Django 支持直接在代码中定义数据库的表结构，然后用 django 命令完成数据库的初始化，不需要写 sql 语句。在 Django 中一个数据库表对应一个 Model。

## 创建 Model

Model 的定义文件 models.py 位于 Django 应用目录中，在 models.py 中为每张数据库表创建一个对应的类：

```python
from django.db import models

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
```

上面的创建的两个类 Question 和 Choice，分别对应同名的数据库表，类成员对应表中的字段。

需要特别关注的是每个字段的类型，`models.IntegerField`、`models.CharField`分别对应不同的数据库表字段类型，并且通过传入参数控制字段的特性。

Models 可以说是 Django 中最重要的部分，Django 文档中有 [Models 的专题介绍](https://docs.djangoproject.com/en/2.2/topics/db/models/)，内容比较多。

## 类型成员类型与数据库字段类型

```python
# 定长字符串
stock = models.CharField(max_length=20)

# 不定长字符串
main_content = models.TextField()

# 整数
votes = models.IntegerField(default=0)

# 时间
update_date = models.TimeField(null=False)
```

## Field Options

Field Options 是在声明类成员时传入的参数（例如 max_length=20），[Django Model Field options][1] 列出了 Django 支持的所有 Field Options。

例如：

```python
# 声明为主键
index_id = models.CharField(max_length=40,null=False, primary_key=True)
```

## 在 Meta 中设置联合主键等属性

在 Model 的子类中，也就是上面 Question 等类中，添加一个 Meta 类，覆盖父类中的对应设置。Meta 类的属性在 [Model Meta options](https://docs.djangoproject.com/en/2.2/ref/models/options/) 中可以找到，其中 [unique-together](https://docs.djangoproject.com/en/2.2/ref/models/options/#unique-together) 是用来设置联合主键的，如下：

```python
class Movie(models.Model):
    name = models.CharField(max_length=200)
    site = models.CharField(max_length=50)
    page_url = models.TextField()
    cover_url = models.TextField()
    description = models.TextField()
    description_extra = models.TextField()
    date = models.CharField(max_length=50)
    class Meta:
        unique_together = ['name', 'site']
```

## 激活 Model

>这里以 Django 应用 poll 为例，它在 [第一个Django应用](./first-app.md) 中创建。

如果使用的是 mysql 数据库，需要安装 mysqlclient（安装时如果报错 ld: library not found for -lssl...command 'clang' failed with exit status 1，是因为没有找到 ssl 连接库）：

```sh
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
pip install mysqlclient
```

在 models.py 中定义的 Model 不会立即生效，首先要在项目的 settings.py 中引入应用的配置：

```python
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'polls.apps.PollsConfig',
]
```

然后运行下面的命令，将应用 polls 中定义的 Model 刷到数据库中，即创建对应的数据库表：

```sh
python manage.py makemigrations polls
python manage.py migrate
```

如果没有在 settings.py 中引入应用 polls，会遇到下面的错误：

```sh
(env) lijiaos-mbp:mysite lijiao$ python manage.py makemigrations polls
No installed app with label 'polls'.
```

激活时使用的第一个命令是 `makemigrations polls`，生成对应的数据库初始化文件 polls/migrations/0001_initial.py：

```sh
(env) 192:mysite lijiao$ python manage.py makemigrations polls
Migrations for 'polls':
  polls/migrations/0001_initial.py
    - Create model Question
    - Create model Choice
```

第二个命令`migrate`是将所有还没有应用到数据库中变更刷到数据库中：

```sh
(env) 192:mysite lijiao$ python manage.py migrate
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, polls, sessions
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying auth.0001_initial... OK
  Applying admin.0001_initial... OK
  Applying admin.0002_logentry_remove_auto_add... OK
  Applying admin.0003_logentry_add_action_flag_choices... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying auth.0002_alter_permission_name_max_length... OK
  Applying auth.0003_alter_user_email_max_length... OK
  Applying auth.0004_alter_user_username_opts... OK
  Applying auth.0005_alter_user_last_login_null... OK
  Applying auth.0006_require_contenttypes_0002... OK
  Applying auth.0007_alter_validators_add_error_messages... OK
  Applying auth.0008_alter_user_username_max_length... OK
  Applying auth.0009_alter_user_last_name_max_length... OK
  Applying auth.0010_alter_group_name_max_length... OK
  Applying auth.0011_update_proxy_permissions... OK
  Applying polls.0001_initial... OK
  Applying sessions.0001_initial... OK
```

可以用下面的命令查看对应的SQL语句：

```sh
python manage.py sqlmigrate polls 0001
```

## 更新 Model

在 models.py 中修改了 Model 的定义之后，重新执行下面的命令，就会将最新的定义刷新到数据库中：

```sh
python manage.py makemigrations polls
python manage.py migrate
```

## 参考

[1]: https://docs.djangoproject.com/en/2.2/topics/db/models/#field-options "Django Model Field options"

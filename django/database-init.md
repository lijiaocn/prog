# Django数据库初始化

Django支持直接在代码中定义数据库的表结构，然后用django命令完成数据库的初始化，不需要在sql语句。在Django中一个数据库表对应一个Model。

## 创建Model

Model的定义文件models.py位于Django应用目录中，在models.py中创建的每个类对应一张数据库表，例如：

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

上面的代码创建了两个类Qestion和Choice，它们将分别对应同名的数据库表，每个类成员对应表中的一个字段。

需要特别关注的是每个字段的类型，`models.IntegerField`、`models.CharField`分别对应不同的数据库表字段类型，并且通过传入参数控制字段的特性。

Models可以说是Django中最重要的部分，Django文档中有[Models的专题介绍](https://docs.djangoproject.com/en/2.2/topics/db/models/)。内容比较多，放在后面单独阐述。

可以在 Model 的子类中，也就是上面 Question 等子类中，添加一个 Meta 类，覆盖父类中的对应设置。Meta 类的属性在 [Model Meta options](https://docs.djangoproject.com/en/2.2/ref/models/options/) 中可以找到，其中 [unique-together](https://docs.djangoproject.com/en/2.2/ref/models/options/#unique-together) 是用来设置联合主键的，如下：

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

如果使用的是 mysql 数据库，需要安装 mysqlclient（安装时如果报错 ld: library not found for -lssl...command 'clang' failed with exit status 1，是因为没有找到 ssl 连接库）：

```sh
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
pip install mysqlclient
```

在models.py中定义的Model不会立即生效，首先要在项目的settings.py中引入应用的配置：

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

然后运行下面的命令，将应用的polls中定义的Model刷到数据库中，即创建对应的数据库表：

```sh
python manage.py makemigrations polls
python manage.py migrate
```

如果没有在settings.py中引入应用，会遇到下面的错误：

```sh
(env) lijiaos-mbp:mysite lijiao$ python manage.py makemigrations polls
No installed app with label 'polls'.
```

激活时使用的第一个命令`makemigrations polls`是生成对应的数据库初始化文件polls/migrations/0001_initial.py：

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

## 更新Model

在models.py中修改了Model的定义之后，只需要重新执行下面的命令，就会将最新的定义刷新到数据库中：

```sh
python manage.py makemigrations polls
python manage.py migrate
```

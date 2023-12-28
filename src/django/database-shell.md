<!-- toc -->
# 在命令行操作数据库

Django提供了一个[shell命令](https://docs.djangoproject.com/en/2.2/intro/tutorial02/#playing-with-the-api)，可以直接和数据库交互：

```sh
python manage.py shell
```

这个命令实际上是启动了python，并导入了django项目，从而可以直接引用Django的项目代码，尽进行操作，例如：

```sh
(env) 192:mysite lijiao$ python manage.py shell
Python 3.7.2 (default, Feb 12 2019, 08:15:36)
[Clang 10.0.0 (clang-1000.11.45.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> from polls.models import Choice, Question
>>> Question.objects.all()
<QuerySet []>
>>> from django.utils import timezone
>>> q = Question(question_text="What's new?", pub_date=timezone.now())
>>> q.save()
>>> q.id
1
>>> q.question_text
"What's new?"
>>> q.pub_date
datetime.datetime(2019, 4, 5, 7, 20, 13, 842645, tzinfo=<UTC>)
>>> q.question_text = "What's up?"
>>> q.save()
>>> Question.objects.all()
<QuerySet [<Question: Question object (1)>]>
```

# Django中view的创建

view就是一个一个页面，前面在创建应用的时候创建了一个简单的index view。这里演示更多view的用法。每个view有一个独立无二的url，对应一个python函数，这个python函数负责渲染页面并返回给请求端。

urls和views的对应关系用[URL dispatcher](https://docs.djangoproject.com/en/2.2/topics/http/urls/)描述。

## 带路径参数的views

在Django应用polls的views.py中创建几个带有传入参数的views：

```python
def detail(request, question_id):
    return HttpResponse("You're looking at question %s." % question_id)

def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)

def vote(request, question_id):
    return HttpResponse("You're voting on question %s." % question_id)
```

注意这几个views的传入参数除了request，还有一个question_id，question_id是从url中解析出来的，是在设置urls和views的对应关系是设定的，例如，在polls/urls.py中设置如下：

```python
from django.urls import path

from . import views

urlpatterns = [
    # ex: /polls/
    path('', views.index, name='index'),
    # ex: /polls/5/
    path('<int:question_id>/', views.detail, name='detail'),
    # ex: /polls/5/results/
    path('<int:question_id>/results/', views.results, name='results'),
    # ex: /polls/5/vote/
    path('<int:question_id>/vote/', views.vote, name='vote'),
]
```

urls中的`<int:question_id>`就是解析给question_id的数值，类型是int。

在url中带的参数，被解析给view的参数，然后在view的处理函数中被返回，例如：

```
$ curl 127.0.0.1:8000/polls/3/
You're looking at question 3.

$ curl 127.0.0.1:8000/polls/3/results/
You're looking at the results of question 3.

$ curl 127.0.0.1:8000/polls/3/vote/
You're voting on question 3.
```

## views中的准备响应数据

views最终要返回一个HttpResponse类型的变量或者抛出Http404等异常，在views对应的函数中，可以用各种方式生成要返回的数据，譬如读取数据库、通过运算计算出等。

例如把index的view进行扩展，返回从数据库中查询到数据：

```python
from .models import Question

def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    output = ', '.join([q.question_text for q in latest_question_list])
    return HttpResponse(output)
```

这个views方法的实现同时演示了在Django中如何引用models，并通过models查询数据库。

## views中使用页面模版

前面的几个views都是硬编码了返回的数据，没有数据和样式分开，这样会导致要修改返回的数据的样式时，必须修改代码。可以用页面模版(templates)功能将数据和样式分开。

Django项目的[settings.py](https://docs.djangoproject.com/en/2.2/ref/settings/#std:setting-TEMPLATES)中配置了页面模版类型，例如：

```python
TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'APP_DIRS': True,
    },
]
```

Django支持的页面模版有：

	'django.template.backends.django.DjangoTemplates'
	'django.template.backends.jinja2.Jinja2'

页面模版文件默认位于Django应用的templates目录中，创建一个页面模版文件polls/templates/polls/index.html：

```django
{% if latest_question_list %}
    <ul>
    {% for question in latest_question_list %}
        <li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
    {% endfor %}
    </ul>
{% else %}
    <p>No polls are available.</p>
{% endif %}
```

页面模版文件中可以进行逻辑判断，根据传入的参数值生成不同的内容。

然后在views中加载页面模版文件，并在渲染后返回：

```python
from django.http import HttpResponse
from django.template import loader

from .models import Question


def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    template = loader.get_template('polls/index.html')
    context = {
        'latest_question_list': latest_question_list,
    }
    return HttpResponse(template.render(context, request))
```

这时候请求index view，返回下面的数据：

```sh
$ curl http://127.0.0.1:8000/polls/

    <ul>

        <li><a href="/polls/1/">What&#39;s up?</a></li>

    </ul>
```

可以用render()函数简化views中的代码：

```python
from django.shortcuts import render

from .models import Question


def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    context = {'latest_question_list': latest_question_list}
    return render(request, 'polls/index.html', context)
```

## views中抛出404异常

当没有找到对应的数据时，抛出404异常：

```python
from django.http import Http404
from django.shortcuts import render

from .models import Question

def detail(request, question_id):
    try:
        question = Question.objects.get(pk=question_id)
    except Question.DoesNotExist:
        raise Http404("Question does not exist")
    return render(request, 'polls/detail.html', {'question': question})
```

可以用`get_object_or_404()`函数简化代码：

```python
from django.shortcuts import get_object_or_404, render

from .models import Question
# ...
def detail(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    return render(request, 'polls/detail.html', {'question': question})
```

对应的模版文件polls/detail.html：

```django
<h1>{{ question.question_text }}</h1>
<ul>
{% for choice in question.choice_set.all %}
    <li>{{ choice.choice_text }}</li>
{% endfor %}
</ul>
```

## 去掉模版文件中硬编码

前面使用的模版文件中，有对url的硬编码，例如：

```django
<li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
```

这样会降低模版文件的自适应能力，可以用urls.py中的定义动态生成路径，例如：

```django
<li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
```

href的值是名为detail的view对应的url，url路径参数的值是question.id。

这样一来，更改view对应的url时，只需要在urls.py中修改，不需要改变页面模版文件。

## 为url设置namespace

Django项目中可能有多个Django应用，每个应用都会定义自己的views，以及对应的urls，不同Django应用的view可能重名，那么要怎样在页面对重名的views进行区分？

答案是在每个应用的urls.py中，定义一个名为app_name的变量，这个变量为urls中添加了一个命名空间，例如polls/urls.py：

```python
from django.urls import path

from . import views

app_name = 'polls'
urlpatterns = [
    path('', views.index, name='index'),
    path('<int:question_id>/', views.detail, name='detail'),
    path('<int:question_id>/results/', views.results, name='results'),
    path('<int:question_id>/vote/', views.vote, name='vote'),
]

```

上面的代码定义了url的命名空间polls，在页面模版中引用对应的views时需要加上`poll:`前缀：

```django
<li><a href="{% url 'polls:detail' question.id %}">{{ question.question_text }}</a></li>
```

## 在views中实现form表单

更改detail.html模版，在其中插入一个表单，注意表单中有一个csrf_token，这是django内置支持的CSRF防御机制:

```django
<h1>{{ question.question_text }}</h1>

{% if error_message %}<p><strong>{{ error_message }}</strong></p>{% endif %}

<form action="{% url 'polls:vote' question.id %}" method="post">
{% csrf_token %}
{% for choice in question.choice_set.all %}
    <input type="radio" name="choice" id="choice{{ forloop.counter }}" value="{{ choice.id }}">
    <label for="choice{{ forloop.counter }}">{{ choice.choice_text }}</label><br>
{% endfor %}
<input type="submit" value="Vote">
</form>
```

在接收表单请求的views中处理表单数据：

```python
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import get_object_or_404, render
from django.urls import reverse

from .models import Choice, Question
# ...
def vote(request, question_id):
    question = get_object_or_404(Question, pk=question_id)
    try:
        selected_choice = question.choice_set.get(pk=request.POST['choice'])
    except (KeyError, Choice.DoesNotExist):
        # Redisplay the question voting form.
        return render(request, 'polls/detail.html', {
            'question': question,
            'error_message': "You didn't select a choice.",
        })
    else:
        selected_choice.votes += 1
        selected_choice.save()
        # Always return an HttpResponseRedirect after successfully dealing
        # with POST data. This prevents data from being posted twice if a
        # user hits the Back button.
        return HttpResponseRedirect(reverse('polls:results', args=(question.id,)))
```

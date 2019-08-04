# Django Generic View的使用

使用Django Generic Views可以减少大量代码。

## Generic Views方式中url定义

```python
from django.urls import path

from . import views

app_name = 'polls'
urlpatterns = [
    path('', views.IndexView.as_view(), name='index'),
    path('<int:pk>/', views.DetailView.as_view(), name='detail'),
    path('<int:pk>/results/', views.ResultsView.as_view(), name='results'),
    path('<int:question_id>/vote/', views.vote, name='vote'),
]
```

注意前三个path的第二个参数和以前不同，它们是继承了generic中的类的对象，在应用的views.py中定义。

## Generic Views方式中view的定义

```python
from django.http import HttpResponseRedirect
from django.shortcuts import get_object_or_404, render
from django.urls import reverse
from django.views import generic

from .models import Choice, Question


class IndexView(generic.ListView):
    template_name = 'polls/index.html'
    context_object_name = 'latest_question_list'

    def get_queryset(self):
        """Return the last five published questions."""
        return Question.objects.order_by('-pub_date')[:5]


class DetailView(generic.DetailView):
    model = Question
    template_name = 'polls/detail.html'


class ResultsView(generic.DetailView):
    model = Question
    template_name = 'polls/results.html'


def vote(request, question_id):
    ... # same as above, no changes needed.
```

这里用到的[generic.ListView](https://docs.djangoproject.com/en/2.2/ref/class-based-views/generic-display/#django.views.generic.list.ListView)和[generic.DetailView](https://docs.djangoproject.com/en/2.2/ref/class-based-views/generic-display/#django.views.generic.detail.DetailView)是两个通用的view，分别用来渲染列表和Python对象。

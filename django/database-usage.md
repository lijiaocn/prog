<!-- toc -->
# Django：数据库查询写入

写入新的记录：

```python
from movie.models import Movie
...
m = Movie()
m.XXX = XXX
m.save()
```

查询记录：

```python
m = Movie.objects.get(name=i.name,site=i.site)
m = Movie.objects.get(name=i.name,site=i.site)
```

条件查询，[QuerySet API reference][1]：

```python
items = Movie.objects.filter()
items = Movie.objects.filter().order_by('name')
```

查询结果排序：

```python
from django.db.models.functions import Coalesce

items = Question.objects.filter(market="sz").order_by(Coalesce('stock_code', 'answer_date').desc())
```

## 参考

[1]: https://docs.djangoproject.com/en/2.2/ref/models/querysets/ "Django: QuerySet API reference"

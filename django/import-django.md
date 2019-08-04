# 独立文件导入 Django 环境

创建文件 bin/movie-spider.py，导入 django 环境：

```python
import os
import sys
import django
# load django environment
sys.path.append(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
os.environ['DJANGO_SETTINGS_MODULE'] = 'spider3.settings'
django.setup()
```
然后导入并使用 django 项目中的代码，譬如使用 model：

```python
from movie.models import Movi
```

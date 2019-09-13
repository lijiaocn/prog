<!-- toc -->
# Django使用过程遇到的问题

## LookupError: No installed app with label 'admin'.

一个空的Django项目运行时直接报错：`LookupError: No installed app with label 'admin'.`。

Django版本是2.2，出现这个错误原因是系统上的sqlite版本太低，低于django2.2的要求：

```
  File "/root/discount/env/lib/python3.6/site-packages/django/db/backends/sqlite3/base.py", line 66, in <module>
    check_sqlite_version()
  File "/root/discount/env/lib/python3.6/site-packages/django/db/backends/sqlite3/base.py", line 63, in check_sqlite_version
    raise ImproperlyConfigured('SQLite 3.8.3 or later is required (found %s).' % Database.sqlite_version)
django.core.exceptions.ImproperlyConfigured: SQLite 3.8.3 or later is required (found 3.7.17).
```

在settings.py配置配置其它数据库，比如mysql，不要使用sqlite，或者将本地的sqlite升级。

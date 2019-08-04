# Django中使用Redis缓存

[django-redis documentation][1]是python库，将redis与Django无缝结合了起来。

## 安装Redis

```
yum install -y redis
```

redis的配置文件是/etc/redis.conf，

```
maxmemory 30mb
maxmemory-policy volatile-lru
databases 1
```

启动，默认只监听地址是127.0.0.1:6739：

```
systemctl start redis
```

验证：

```
# redis-cli  ping
PONG
```

## 安装配置django-redis

安装：

```sh
pip install django-redis
```

在settings.py中配置：

```python
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/0",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}
```

## 使用redis作为session backend

将redis作为session backend不需要额外设置，直接启用session backend即可：

```
SESSION_ENGINE = "django.contrib.sessions.backends.cache"
SESSION_CACHE_ALIAS = "default"
```

## 操作redis

```python
(env) lijiaos-mbp:mysite lijiao$ python manage.py shell
Python 3.7.2 (default, Feb 12 2019, 08:15:36)
[Clang 10.0.0 (clang-1000.11.45.5)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
(InteractiveConsole)
>>> from django.core.cache import cache
>>> cache.set("foo", "value", timeout=25)
True
>>> cache.ttl("foo")
20
>>> cache.get("foo")
'value'
>>>
```

在redis中看到的数据这样的：

```sh
127.0.0.1:6379> keys *
1) ":1:foo"
127.0.0.1:6379> get ":1:foo"
"\x80\x04\x95\t\x00\x00\x00\x00\x00\x00\x00\x8c\x05value\x94."
```


[1]: http://niwinz.github.io/django-redis/latest/ "django-redis documentation"
[2]: https://django-redis-chs.readthedocs.io/zh_CN/latest/ "django-redis 中文文档"

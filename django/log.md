<!-- toc -->
# Django的日志管理

Django的日志在项目的settings.py中配置[LOGGING][1]。

## Django中使用logging

在项目的settings.py中进行如下配置：

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'class': 'logging.FileHandler',
            'filename': '/path/to/django/debug.log',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'DEBUG',
            'propagate': True,
        },
    },
}
```

然后就可以在Django应用中直接使用logging：

```python
import logging

logger = logging.getLogger(__name__)

def auth(request):
    logger.info("this is log")
```

这时候只能打印出django模块的日志，上面的“this is log”不会出现日志中，这是因为上面的settings.py中只配置了django，还需要加上我们自己的django应用:

```
'loggers': {
    'django': {
        'handlers': ['file'],
        'level': 'DEBUG',
        'propagate': True,
    },
    'polls': {
        'handlers': ['file'],
        'level': 'DEBUG',
        'propagate': True,
    }
```

## 更复杂的logging配置

logging的灵活，下面是一个比较复杂的logging配置：

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} {asctime} {module} {process:d} {thread:d} {message}',
            'style': '{',
        },
        'simple': {
            'format': '{levelname} {message}',
            'style': '{',
        },
    },
    'filters': {
        'special': {
            '()': 'project.logging.SpecialFilter',
            'foo': 'bar',
        },
        'require_debug_true': {
            '()': 'django.utils.log.RequireDebugTrue',
        },
    },
    'handlers': {
        'console': {
            'level': 'INFO',
            'filters': ['require_debug_true'],
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
            'filters': ['special']
        }
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'propagate': True,
        },
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': False,
        },
        'myproject.custom': {
            'handlers': ['console', 'mail_admins'],
            'level': 'INFO',
            'filters': ['special']
        }
    }
}
```

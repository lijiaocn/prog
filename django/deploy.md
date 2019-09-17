<!-- toc -->
#  用WSGI方式部署Django服务

Django的主要部署平台是WSGI，WSGI是python的web服务和应用标准，文档[How to deploy with WSGI][1]中介绍了四种方式：使用mod_swgi模块的Apache，Gunicorn、uWSGI。

## 指定配置文件

Django项目中的wsgi.py就是支持WSGI的web server要加载的应用入口文件。wsgi.py中要设置环境变量`DJANGO_SETTINGS_MODULE`，指向Django应用的配置模块，默认是项目目录中mysite/settings.py：

```python
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "mysite.settings")
```

`DJANGO_SETTINGS_MODULE`的值可以灵活设置，因此可以为生产环境、测试开发环境可以使用不同的settings.py文件。

## 添加wsgi中间件

WSGI的一个主要卖点是可以很方便的添加中间处理环节，这个功能叫做[wsgi middleware][2]，可以将开发的中间价很方便的套在Django应用上，例如：

```python
from helloworld.wsgi import HelloWorldApplication
application = get_wsgi_application()
application = HelloWorldApplication(application)
```

通过`get_wsgi_application()`返回的application是原始的Django应用。

## wsgi资料

wsgi的配置样例，[Quick Configuration Guide][3]：

```conf
<VirtualHost *:80>

    ServerName www.example.com
    ServerAlias example.com
    ServerAdmin webmaster@example.com

    DocumentRoot /usr/local/www/documents

    <Directory /usr/local/www/documents>
    <IfVersion < 2.4>
        Order allow,deny
        Allow from all
    </IfVersion>
    <IfVersion >= 2.4>
        Require all granted
    </IfVersion>
    </Directory>

    WSGIScriptAlias /myapp /usr/local/www/wsgi-scripts/myapp.wsgi

    <Directory /usr/local/www/wsgi-scripts>
    <IfVersion < 2.4>
        Order allow,deny
        Allow from all
    </IfVersion>
    <IfVersion >= 2.4>
        Require all granted
    </IfVersion>
    </Directory>

</VirtualHost>

```

[1]: https://docs.djangoproject.com/en/2.2/howto/deployment/wsgi/ "How to deploy with WSGI"
[2]: https://www.python.org/dev/peps/pep-3333/#middleware-components-that-play-both-sides  "WSGI middleware"
[3]: https://modwsgi.readthedocs.io/en/develop/user-guides/quick-configuration-guide.html "Quick Configuration Guide"

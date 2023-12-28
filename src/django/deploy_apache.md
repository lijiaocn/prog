<!-- toc -->
# 在Apache中部署Django应用

在apache中部署的时候，需要启用apache的[mod_wsgi][1]模块，这个模块用来兼容python的wsgi应用，包括Django。[How to use Django with Apache and mod_wsgi][2]中有详细介绍。

## 安装Apache和mod_wsgi

建议使用第二种方式，安装ius源中python**wsgi。

### 使用yum直接安装mod_wsgi

CentOS中提供了mod_wsgi的安装包，安装的时候会连同依赖的apache（在CentOS中名为httpd）一起安装：

```bash
$ yum install -y mod_wsgi
Dependencies Resolved

================================================================================
 Package            Arch          Version                       Repository
                                                                           Size
================================================================================
Installing:
 mod_wsgi           x86_64        3.4-18.el7                    os         77 k
Installing for dependencies:
 apr                x86_64        1.4.8-3.el7_4.1               os        103 k
 apr-util           x86_64        1.5.2-6.el7                   os         92 k
 httpd              x86_64        2.4.6-88.el7.centos           os        2.7 M
 httpd-tools        x86_64        2.4.6-88.el7.centos           os         90 k
 mailcap            noarch        2.1.41-2.el7                  os         31 k
```

但是根据[Django Apache and Virtualenv ImportError: No module named site][3]中的说法，如果wsgi编译时使用的python版本和django应用使用python版本不一致，可能会出现找不到python package的情况：

```sh
#日志文件 /var/log/httpd/error_log
ImportError: No module named site
ImportError: No module named site
ImportError: No module named site
ImportError: No module named site
ImportError: No module named site
ImportError: No module named site
```

[mod_wsgi][4]中建议使用pip安装，看了一下还是挺麻烦的。[Django Apache and Virtualenv ImportError: No module named site][3]中的标题为`Solved in CentOS 7 with Apache 2.4.6`答案中给出的用ius源安装的方法比较方便。

### 使用ius源中的python36u-mod_wsgi

首先安装[ius](https://ius.io/GettingStarted/)源：

```sh
$ curl https://setup.ius.io/ | bash
```

ius源中包含了不同python版本的mod_wsgi：

```sh
$ yum search mod_wsgi
python35u-mod_wsgi-debuginfo.x86_64 : Debug information for package python35u-mod_wsgi
python36u-mod_wsgi-debuginfo.x86_64 : Debug information for package python36u-mod_wsgi
koschei-frontend.noarch : Web frontend for koschei using mod_wsgi
mod_wsgi.x86_64 : A WSGI interface for Python web applications in Apache
python35u-mod_wsgi.x86_64 : A WSGI interface for Python web applications in Apache
python36u-mod_wsgi.x86_64 : A WSGI interface for Python web applications in Apache
viewvc-httpd-wsgi.noarch : ViewVC configuration for Apache/mod_wsgi
```

我使用的是python3.6，直接安装python36u-mod_wsgi，如果ius里也没有你用的版本，那么就考虑自己编译安装[mod_wsgi][4]。

```sh
yum erase mod_wsgi  # 卸载之前安装的mod_wsgi
yum install -y python36u-mod_wsgi
```

安装完成之后会生成文件 /etc/httpd/conf.modules.d/10-wsgi-python3.6.conf，这个就是新安装的apache模块的配置文件。

## 在httpd.conf配置wsgi应用

Apache和mod_wsgi安装完成之后，在httpd.conf中添加下面的配置（路径根据实际情况配置），可以直接在` /etc/httpd/conf/httpd.conf`中添加，也可以在`/etc/httpd/conf.d/`单独创建一个包含下面配置的文件：

```conf
WSGIScriptAlias / /path/to/mysite.com/mysite/wsgi.py
WSGIPythonHome /path/to/venv
WSGIPythonPath /path/to/mysite.com

<Directory /path/to/mysite.com/mysite>
<Files wsgi.py>
Require all granted
</Files>
</Directory>
```

`WSGIScriptAlias`后面紧跟着的是应用的base URL路径，然后是应用的wsgi文件。

如果Django应用使用的是virtualenv创建的运行环境，用`WSGIPythonHome`指定virtuanenv的路径。

`WSGIPythonPath`指定整个项目的文件目录，是import时的根路径，确保所有的项目文件都在这个目录中。

`<Directory>`中的配置是允许apache读取wsgi.py文件。

Apache2.4以前的版本，需要把`Require all granted`换成`Allow from all`。


如果配置不生效，到`/var/log/httpd/error_log`中找线索。

## 将mod_wsgi配置成daemon模式

在非windows平台上，mod_wsgi推荐使用daemon模式。使用daemon模式后，前面的配置的`WSGIPythonHome`和`WSGIPythonPath`要去掉，改为在`WSGIDaemonProcess`中用`python-home`和`python-path`指定，修改后的配置如下：

```conf
WSGIProcessGroup example.com
WSGIDaemonProcess example.com python-home=/path/to/venv python-path=/path/to/mysite.com lang='en_US.UTF-8' locale='en_US.UTF-8'
WSGIScriptAlias / /path/to/mysite.com/mysite/wsgi.py process-group=example.com
```

注意WSGIDaemonProcess一行中的en_US.UTF-8，如果Django应用会打印utf-8编码的字符，需要将wsgilang和local设置为UTF-8，否则wsgi会报错：

	UnicodeEncodeError: 'ascii' codec can't encode characters in position 154-155: ordinal not in range(128)

如果在shell终端用`python ./manage.py runserver`运行时也报同样的错误，修改/etc/locale.conf文件后重新登录：

```sh
$ cat /etc/locale.conf
LANG=en_US.utf8
LC_CTYPE=en_US.UTF-8
```

## 一个配置wsgi配置样例

下面这个独立的（[Apache Virtual Host Containers in Separate Files][5])配置文件中，将django的日志也拆分了出来：

```sh
# cat /etc/httpd/conf.d/discount.conf
<VirtualHost *:80>
  ServerName 127.0.0.1    # 根据实际情况设置
  WSGIProcessGroup discount
  WSGIDaemonProcess discount python-home=/opt/discount/env  python-path=/opt/discount/mysite lang='en_US.UTF-8' locale='en_US.UTF-8'
  WSGIScriptAlias / /opt/discount/mysite/mysite/wsgi.py process-group=discount

  <Directory /opt/discount/mysite/mysite/>
  <Files wsgi.py>
  Require all granted
  </Files>
  </Directory>

  LogLevel info
  ErrorLog "logs/discount_error_log"
  CustomLog "logs/discount_access_log" combined
</VirtualHost>
```

上面的logs目录是/etc/httpd/logs，它是符号链接，链接到了/var/log/httpd。

Django的日志和wsgi的日志是分开的，但是用mod_wsgi运行django应用的时候，Django的日志目录需要能够被apache用户读写，因为httpd进程的用户是apache。

最好创建一个单独的目录，并且目录所属修改为apache：

	mkdir -p /var/log/discount/
	chwon apache:apache /var/log/discount/

注意Django日志文件不能在/tmp目录中，Django日志位于/tmp目录中时，wsgi虽然不报错，但是日志文件也不会创建，比较奇怪。

下面是Django的日志配置（在项目的settings.py中）:

```python
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s',
        }
    },
    'handlers': {
        'file': {
            'level': 'DEBUG',
            'formatter': 'standard',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': '/var/log/discount/discount.log',
            'maxBytes': 1024*1024*100,
            'backupCount': 10,
        },
        'console':{
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'standard',
        }
    },
    'loggers': {
        'django': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        },
        'wechat': {
            'handlers': ['file'],
            'level': 'INFO',
            'propagate': True,
        }
    },
}
```

## 文件服务器

Django本身不提供文件服务，静态文件服务的需要用nginx、apache等软件实现。

[1]: https://modwsgi.readthedocs.io/en/develop/ "mod_wsgi"
[2]: https://docs.djangoproject.com/en/2.2/howto/deployment/wsgi/modwsgi/ "How to use Django with Apache and mod_wsgi"
[3]: https://stackoverflow.com/questions/41005030/django-apache-and-virtualenv-importerror-no-module-named-site "Django Apache and Virtualenv ImportError: No module named site"
[4]: https://pypi.org/project/mod_wsgi/ "mod_wsgi 4.6.5 "
[5]: https://wiki.centos.org/TipsAndTricks/ApacheVhostDir "Apache Virtual Host Containers in Separate Files"

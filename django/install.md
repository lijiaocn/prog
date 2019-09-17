<!-- toc -->
# Django环境安装


确保有python命令和pip命令，python分为python2和python3，建议直接上手[python3](https://docs.python.org/3/contents.html)，python2.7是python2的最后一个版本。

[Should I use Python 2 or Python 3 for my development activity?](https://wiki.python.org/moin/Python2orPython3)

[How To Port Python 2 Code to Python 3 ](https://www.digitalocean.com/community/tutorials/how-to-port-python-2-code-to-python-3)

安装virtualenv：

	pip install virtualenv

用virtualenv创建python运行环境：

	mkdir django-py3
	cd django-py3
	virtualenv  -p python3 env

进入virtualenv创建的python运行环境：

	source env/bin/activate

用pip安装django：

	pip install Django

也可以下载django源代码安装：

	git clone https://github.com/django/django.gi
	pip install -e django/

验证django环境：

	>>> import django
	>>> print(django.get_version())
	2.2

或者：

	$python -m django --version
	2.2

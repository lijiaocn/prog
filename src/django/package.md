<!-- toc -->
# 在Django项目自定义Package

一些常用的代码可以做成Package，从而可以在多个地方复用，在Django项目代码中可以直接应用自定义的Package。


## 在Django项目中创建Pakcage

在Django项目的目录如下，子目录mysite是django项目的配置package，wechat是Django应用。

```
▾ mysite/
  ▸ mysite/
  ▸ wechat/
    __init__.py
    manage.py*
```

在Django的目录中创建一个wechatsdk的package，wechatsdk目录中要有`__init__.py`文件：

```
▾ mysite/
  ▸ mysite/
  ▸ wechat/
  ▸ wechatsdk/
      __init__.py
      auth.py
      msgtype.py
    __init__.py
    manage.py*
```

然后就可以在Django应用引用wechatsdk里，例如在Django应用wechat/views.py中引用wechatsdk：

```python
from wechatsdk import msgtype
from wechatsdk import auth
```

在用“python ./manager.py runserver”启动Django服务的时候，会从当前目录中查找package，因此wechatsdk能够被找到。如果IDE IntellJ Idea要正确地找到wechatsdk，项目的根目录需要是wechatsdk的父目录mysite，可以在File->Project Structure -> Modules中修改Content Root。

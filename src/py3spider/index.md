<!-- toc -->
# Python3 爬虫开发

Python2 马上就要不维护了，现在要尽量使用 Python3，正好`崔庆才`写了一本[《Python 3网络爬虫开发实战》][4]，介绍了 Requests、Selenium、PhantomJS、Beautiful Soup 等 python 库的用法。

用 virtualenv 创建的 python 运行环境，指定用 python3，并安装要用到的库：

```sh
pip install virtualenv
mkdir spider3
cd spider3

virtualenv -p python3 env
source env/bin/activate
pip3 install django mysqlclient requests beautifulsoup4
```

随时将依赖的 python 包更新到 requirements.txt 文件中：

```sh
pip3 freeze > requirements.txt
```

## 参考

1. [李佶澳的博客][1]
2. [Python3网络爬虫开发实战教程][2]
3. [What is Selenium?][3]
4. [崔庆才：《Python 3网络爬虫开发实战》][4]

[1]: https://www.lijiaocn.com "李佶澳的博客"
[2]: https://cuiqingcai.com/5052.html "Python3网络爬虫开发实战教程"
[3]: https://www.seleniumhq.org/ "What is Selenium?"
[4]: https://union-click.jd.com/jdc?e=&p=AyIGZRtYFAcXBFIZWR0yEgRXGVkRBxM3EUQDS10iXhBeGlcJDBkNXg9JHU4YDk5ER1xOGRNLGEEcVV8BXURFUFdfC0RVU1JRUy1OVxUBEAVXH14UMlYDHU8Sd19AYigcI0NLSQEKezN3QmILWStaJQITBlQbWRUHEwJlK1sSMkBpja3tzaejG4Gx1MCKhTdUK1sRBRcOXR1dHQsQAlYrXBULIkUQXw5dbFdZA08eTFZRN2UrWCUyIgdlGGtXbBpVBk4JHAARDgBMDhALRQMGGA4RCkIDVkxYRwEQU1dJaxcDEwNc "崔庆才：《Python 3网络爬虫开发实战 》"

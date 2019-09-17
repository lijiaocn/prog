<!-- toc -->
# Python3爬虫开发 -- 请求库

请求库用来发送 http 请求，获取目标页面。

[urllib](https://docs.python.org/3/library/urllib.html) 是 Python3 内置的 HTTP 请求库。

```python
import urllib.request as request

if __name__ == "__main__":
    try:
        resp = request.urlopen(url="http://www.baidu.com")
    except Exception as e:
        print(str(e))
    else:
        print(type(resp))
        print(resp.info())
        if resp.readable:
            data = resp.read()
            print(type(data))
            print("%s" % data.decode("utf-8"))
        resp.close()
    finally:
        None
```

[Requests](https://github.com/requests/requests) 是一个发送 http 请求的 python 库，[英文文档](https://2.python-requests.org/en/master/)，[中文文档](http://2.python-requests.org/zh_CN/latest/)：

	pip3 install requests

[Selenium](https://github.com/SeleniumHQ/selenium/tree/master/py) 是一个用于 Web 自动化测试的浏览器，能够用代码控制浏览器内操作的特性使 Selenium 具有更广阔的应用空间，[英文文档](https://selenium-python.readthedocs.io/)、[中文文档](https://selenium-python-zh.readthedocs.io/en/latest/)：

	pip3 install selenium

[Chrome Driver](https://sites.google.com/a/chromium.org/chromedriver) 和 [Gecko Driver](https://github.com/mozilla/geckodriver) 是配合 Selenium 使用的，分别用来驱动 Chrome 浏览器和 Firefox 浏览器，安装方法见：[chromedriver](https://cuiqingcai.com/5135.html) 和 [geckodriver](https://cuiqingcai.com/5153.html) 。

[Phantomjs](http://phantomjs.org) 是无界面的 WebKit 浏览器，无界面运行效率高，需要 [下载安装](https://phantomjs.org/download.html) 。可以被 Selenium 驱动，如下：

```python
from selenium import webdriver
browser = webdriver.PhantomJS()
browser.get('https://www.baidu.com')
print(browser.current_url)
```

[aiohttp](https://github.com/aio-libs/aiohttp) 是一个异步发送 http 请求的 python 库，[英文文档](https://aiohttp.readthedocs.io/en/stable/)，采用异步机制，效率大大提高。

	pip3 install aiohttp

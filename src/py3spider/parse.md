<!-- toc -->
# Python3爬虫开发 -- 解析库

[lxml](https://github.com/lxml/lxml) 支持 HTML、XML 解析，支持 XPath 解析方式。

	pip3 install lxml

[Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/bs4/doc) 支持 HTML、XML 解析，API 强大，解析方法多，依赖前面的 lxml。

	pip3 install beautifulsoup4

```python
import urllib.request as request
from bs4 import BeautifulSoup

if __name__ == "__main__":
    try:
        resp = request.urlopen(url="http://www.btbtdy.me/hot/month/")
        resp = request.urlopen(url="http://www.baidu.com")
    except Exception as e:
        print(str(e))
    else:
        if not resp.readable:
            resp.close()
            exit(0)

        data = resp.read()
        soup = BeautifulSoup(data,features="html.parser")
        print("%s" % soup.title)

    finally:
        None
```


[pyquery](https://github.com/gawel/pyquery) 使用类似 jQuery 的语法解析 HTML。

	pip3 install pyquery

[tesserocr](https://github.com/sirfz/tesserocr)  是一个 OCR 识别库 [tesserac](https://github.com/tesseract-ocr/tesseract) 的 Python API，可以用来识别图片中的文字。

	yum install -y tesseract
	pip3 install tesserocr pillow

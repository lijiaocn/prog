# Django传入参数的获取

在views的开发一节中讲过，url路径参数可以django直接解析，并作为参数传入views的处理函数。但只有路径参数是不够的，http发起的GET请求是有参数的，以及POST请求提交的body数据都需要解析。

## 请求参数

views函数中第一个参数类型是[HttpRequest][1]，可以从这个参数中解析所有的请求信息。

**HttpRequest.GET**就是GET请求中的所有参数，它的类型是[QueryDict objects][2]。

可以用下面的方式读取参数值，如果参数不存在使用default值：

```python
signature = request.GET.get('signature', default='')
timestamp = request.GET.get('timestamp',default='')
nonce = request.GET.get('nonce',default='')
echostr = request.GET.get('echostr',default='')
```

也可以用map的形式获取，如果参数不存在，会抛出异常：

```python
try:
    signature = request.GET['signature']
    timestamp = request.GET['timestamp']
    nonce = request.GET['nonce']
    echostr = request.GET['echostr']
except Exception as err:
    raise Http404("parameter error")
```
 
异常的具体类型是django.utils.datastructures.MultiValueDictKeyError，它是Python标准异常KeyError的子类。

[1]: https://docs.djangoproject.com/en/2.2/ref/request-response/ "Django Request and response objects"
[2]: https://docs.djangoproject.com/en/2.2/ref/request-response/#querydict-objects "QueryDict objects"

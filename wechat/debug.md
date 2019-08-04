# 微信公众平台接口调试

微信公众平台提供了一个[接口调试工具][1]工具，选择不同的接口类型，可以向微信公众平台发送消息，或者让微信公众平台给开发者的应用发送消息。

## 消息接口调试

消息接口调试中，微信公众平台可以向开发者指定的url中发送开发者自定义的消息。

如果使用Django实现，需要豁免该接口的CSRF检查，否则Django会报错：

```
Forbidden (CSRF cookie not set.): /wechat/
```

豁免方法是为Django的views函数添加一个豁免修饰：

```python
from django.views.decorators.csrf import csrf_exempt
...
@csrf_exempt
def index(request):
  ...
 ```

[1]: https://mp.weixin.qq.com/debug/ "微信公众平台接口调试工具"

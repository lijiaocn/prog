# 淘宝客基础API调用方法

下面以Python API为例。

## 获取APP Key和APP Secret

在淘开放平台的[控制台](http://console.open.taobao.com)中，进入一个应用，就可以看到首页显示有这个应用的App Key和App Secret。

在使用Python API的时候，需要传入这个两个参数：

```
appKey='XXX'
appSecret='XXX'
top.setDefaultAppInfo(appkey, appSecret)
```

## 获取adzone_id

有些接口中需要传入adzone_id。adzone_id是推广位的ID，到淘宝联盟后台中查看：“推广管理”->“推广资源管理”->“推广位管理”。支持四种类型的推广位：网站推广位、APP推广位、导购推广位、软件推广位。

注意后台中没有推广位的创建连接，需要[商品页](http://pub.alimama.com/promo/search/index.htm?q=%E9%9E%8B%E5%AD%90&_t=1554643902198)中随便找一个商品，点击立即推广，在弹出的对话框中，创建推广位。创建之后，回到“推广位管理”页面，就可以看到新建的推广位。

推广位的Pid样式是“mm_33963329_6520758_144842297”，adzone_id是第三段数字。

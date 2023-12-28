<!-- toc -->
# 淘宝客基础API梳理

详情见[淘宝客基础API][1]，这里整理几个主要API的用途。

[1]: https://open.taobao.com/api.htm?docId=24515&docType=2&scopeId=11655 "淘宝客基础API"

## 用关键字查找淘宝客商品和优惠券

[taobao.tbk.item.get](https://open.taobao.com/api.htm?docId=24515&docType=2&scopeId=11655)，用关键字同时从最多10个类目中查询淘宝客商品，可以设置地域、折扣、佣金比率等。

[taobao.tbk.dg.item.coupon.get](https://open.taobao.com/api.htm?docId=29821&docType=2&scopeId=11655)，用关键字同时从最多10个类目中查询优惠券。

## 获取与指定商品相关联的淘宝客商品

[taobao.tbk.item.recommend.get](https://open.taobao.com/api.htm?docId=24517&docType=2&scopeId=11655)，传入一个商品ID，返回与之相关领导商品，最多40个。

## 淘宝客商品详情批量查询

[taobao.tbk.item.info.get](https://open.taobao.com/api.htm?docId=24518&docType=2&scopeId=11655)，最多传入40个商品ID，返回这些商品的详细信息。

## 获取拼团抢购的商品

[taobao.tbk.ju.tqg.get](https://open.taobao.com/api.htm?docId=27543&docType=2&scopeId=11655)，返回指定时间范围内的拼团抢购商品。

## 淘口令生成接口

[taobao.tbk.tpwd.create](https://open.taobao.com/api.htm?docId=31127&docType=2&scopeId=11655)，设置淘口令的弹框内容、跳转目标页、弹框Logo、扩展字段等。

[如何找到自己的淘宝口令ID](https://jingyan.baidu.com/article/c33e3f48d57403ea15cbb507.html)

## 获取指定商品的商品和券二合一推广链接

[taobao.tbk.dg.optimus.material](https://open.taobao.com/api.htm?docId=33947&docType=2&scopeId=11655)，传入商品ID、物料ID，返回“链接-宝贝+券二合一页面链接”等多种促销信息。

[taobao.tbk.dg.material.optional](https://open.taobao.com/api.htm?docId=35896&docType=2&scopeId=11655)，传入关键字、物料ID，返回“链接-宝贝+券二合一页面链接”等多种促销信息。

[taobao.tbk.sc.optimus.material](https://open.taobao.com/api.htm?docId=37884&docType=2&scopeId=11655)，传入商品ID、物料ID，返回“链接-宝贝+券二合一页面链接”等多种促销信息。这个接口和这一节第一个接口的功能基本相同，区别是这个接口需要卖家授权，授权方式见[用户授权介绍](https://open.taobao.com/doc.htm?docId=102635&docType=1)。

“链接-宝贝+券二合一页面链接”非常重要，它是淘口令的跳转目标页地址。

[官方推荐商品库大全](https://tbk.bbs.taobao.com/detail.html?appId=45301&postId=8576096)给出所有的物料ID，物料ID比较乱，分为好几类。


**好券直播**，热门商品，按小时更新，每个material_id 同时产出200款商品。

**大额券**,  折扣力度大的商品，小时更新，每个material_id 同时产出500款商品。

**高佣榜**，高佣商品，最高达90%，按天更新，每个material_id 同时产出500款商品。

**品牌榜**，优质品牌商品，每个material_id 同时产出200款商品。

**母婴主题**，从备孕到儿童不同阶段商品，每个material_id 同时产出1000款商品。

**有好货**，好货精选,每个material_id 同时产出1000款商品。

**潮流范**，时尚流行商品，每个material_id 同时产出1000款商品。

**特惠**，销量高, 评价高,点击转化好, 创意具有吸引力的优质低价宝，每个material_id 同时产出1000款商品 。

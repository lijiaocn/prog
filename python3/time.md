<!-- toc -->
# Python 的时间处理

## 秒转化成日期

```python
import time

def Second2Date(seconds):
    t = time.localtime(seconds)
    return time.strftime("%Y-%m-%d %H:%M:%S",t)

if __name__ == "__main__":
    print(Second2Date(1567672240))
```

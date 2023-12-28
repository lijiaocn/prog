<!-- toc -->
# Python3 的 Package 用法

Package 由一组位于同一目录下的 module 组成，这些 module 纳入 Package 的 namespace 中。不同 Package 中的同名模块因为位于不同的 namespace 中，所以能够被区分。

## Package 的创建

Package 的目录中必须有  `__init__.py` 文件，该文件确保 Package 目录不会被当作普通目录处理：

```sh
sound/                          Top-level package
      __init__.py               Initialize the sound package
      formats/                  Subpackage for file format conversions
              __init__.py
              wavread.py
              wavwrite.py
              aiffread.py
              aiffwrite.py
              auread.py
              auwrite.py
              ...
      effects/                  Subpackage for sound effects
              __init__.py
              echo.py
              surround.py
              reverse.py
              ...
      filters/                  Subpackage for filters
              __init__.py
              equalizer.py
              vocoder.py
              karaoke.py
              ...
```

`__init__.py` 文件内容可以为空，也可以设置 `__all__` 变量，导入 package 时如果使用 `*`，导入的是 `__all__` 中的符号：

```python
__all__ = ["echo", "surround", "reverse"]
```

## 导入 Package

Package 的导入方法和 module 相同：

```python
import sound.effects.echo
from sound.effects import echo
from sound.effects.echo import echofilter
from sound.effects import *

from . import echo
from .. import formats
from ..filters import equalizer
```

`import *` 导入的是 sound.effects 目录中 `__init__.py` 中的 `__all__` 变量里的内容。

## 通过 `__path__` 属性跨目录

`__path__` 属性初始值是包含 `__init__.py` 文件的 package 目录，修改这个属性，可以影响后续的 module 和 package 的查找范围。

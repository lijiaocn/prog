<!-- toc -->
# 文件系统相关操作

## libfuse使用

libfuse的用途以及基础使用方法参考[《Linux FUSE（用户态文件系统）的使用：用libfuse创建FUSE文件系统》](https://www.lijiaocn.com/%E6%8A%80%E5%B7%A7/2019/01/21/linux-fuse-filesystem-in-userspace-usage.html)。

### fuse_get_context

fuse_get_context用于在文件系统操作时获取上下文，在头文件`fuse/fuse.h`中定义：

```c
/**
 * Get the current context
 *
 * The context is only valid for the duration of a filesystem
 * operation, and thus must not be stored and used later.
 *
 * @return the context
 */
struct fuse_context *fuse_get_context(void);
```

返回的结构体fuse_context包含以下信息：

```c
/** Extra context that may be needed by some filesystems
 *
 * The uid, gid and pid fields are not filled in case of a writepage
 * operation.
 */
struct fuse_context {
    /** Pointer to the fuse object */
    struct fuse *fuse;

    /** User ID of the calling process */
    uid_t uid;

    /** Group ID of the calling process */
    gid_t gid;

    /** Thread ID of the calling process */
    pid_t pid;

    /** Private filesystem data */
    void *private_data;

    /** Umask of the calling process (introduced in version 2.8) */
    mode_t umask;
};
```

<!-- toc -->
# socket通信相关操作

## socket管道

`man socketpair`

一次创建两个socket，构成一个未命名的socket pair，写入一个socket的数据能够从另一个socket中收到。

```c
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

int socketpair(int domain, int type, int protocol, int sv[2]);
```

可以作为父子进程的通信方式，例如：

```c
static pid_t get_init_pid_for_task(pid_t task)
{
    int sock[2];
    pid_t pid;
    pid_t ret = -1;
    char v = '0';
    struct ucred cred;

    if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sock) < 0) {
        perror("socketpair");
        return -1;
    }

    pid = fork();
    if (pid < 0)
        goto out;
    if (!pid) {
        close(sock[1]);
        write_task_init_pid_exit(sock[0], task);
        _exit(0);
    }

    if (!recv_creds(sock[1], &cred, &v))
        goto out;
    ret = cred.pid;

out:
    close(sock[0]);
    close(sock[1]);
    if (pid > 0)
        wait_for_pid(pid);
    return ret;
}
```

## 向socket写数据

`man sendmsg`

```c
#include <sys/types.h>
#include <sys/socket.h>

ssize_t send(int sockfd, const void *buf, size_t len, int flags);

ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
               const struct sockaddr *dest_addr, socklen_t addrlen);

ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
```

## 使用socket消息头

下面这些函数提供了操作通过socket发送的数据的消息头的能力：

```c
#include <sys/socket.h>

struct cmsghdr *CMSG_FIRSTHDR(struct msghdr *msgh);
struct cmsghdr *CMSG_NXTHDR(struct msghdr *msgh, struct cmsghdr *cmsg);
size_t CMSG_ALIGN(size_t length);
size_t CMSG_SPACE(size_t length);
size_t CMSG_LEN(size_t length);
unsigned char *CMSG_DATA(struct cmsghdr *cmsg);
```

`msghdr`描述要发送的数据：

```c
/* Structure describing messages sent by
   `sendmsg' and received by `recvmsg'.  */
struct msghdr
  {
    void *msg_name;     /* Address to send to/receive from.  */
    socklen_t msg_namelen;  /* Length of address data.  */

    struct iovec *msg_iov;  /* Vector of data to send/receive into.  */
    size_t msg_iovlen;      /* Number of elements in the vector.  */

    void *msg_control;      /* Ancillary data (eg BSD filedesc passing). */
    size_t msg_controllen;  /* Ancillary data buffer length.
                   !! The type should be socklen_t but the
                   definition of the kernel is incompatible
                   with this.  */

    int msg_flags;      /* Flags on received message.  */
  };
```

可以在其中添加额外的控制信息，`msg_control`指向额外的控制信息，`msg_controllen`是额外的控制信息占用的内存空间。

额外的控制信息用结构体`cmsghdr`表达，msg_control中可以包含多个cmsghdr：

```c
/* Structure used for storage of ancillary data object information.  */
struct cmsghdr
  {
    size_t cmsg_len;        /* Length of data in cmsg_data plus length
                   of cmsghdr structure.
                   !! The type should be socklen_t but the
                   definition of the kernel is incompatible
                   with this.  */
    int cmsg_level;     /* Originating protocol.  */
    int cmsg_type;      /* Protocol specific type.  */
#if (!defined __STRICT_ANSI__ && __GNUC__ >= 2) || __STDC_VERSION__ >= 199901L
    __extension__ unsigned char __cmsg_data __flexarr; /* Ancillary data.  */
#endif
  };
```

用宏`CMSG_FIRSTHDR`获得第一个cmsghdr的地址：

```c
cmsg = CMSG_FIRSTHDR(&msg);
```

用宏`CMSG_DATA`获得cmsghdr的数据地址：

```c
memcpy(CMSG_DATA(cmsg), cred, sizeof(*cred));
```

### 发送端的例子

```c
// lxcfs/bindings.c: 2053
static int send_creds(int sock, struct ucred *cred, char v, bool pingfirst)
{
    struct msghdr msg = { 0 };
    struct iovec iov;
    struct cmsghdr *cmsg;
    //额外的控制信息占用的内存
    char cmsgbuf[CMSG_SPACE(sizeof(*cred))];
    char buf[1];
    buf[0] = 'p';

    if (pingfirst) {
        if (msgrecv(sock, buf, 1) != 1) {
            lxcfs_error("%s\n", "Error getting reply from server over socketpair.");
            return SEND_CREDS_FAIL;
        }
    }

    //控制信息占用的内存的地址写入msg
    msg.msg_control = cmsgbuf;
    msg.msg_controllen = sizeof(cmsgbuf);

    //获取第一个额外控制信息的地址，并设置
    cmsg = CMSG_FIRSTHDR(&msg);
    cmsg->cmsg_len = CMSG_LEN(sizeof(struct ucred));
    cmsg->cmsg_level = SOL_SOCKET;
    cmsg->cmsg_type = SCM_CREDENTIALS;
    memcpy(CMSG_DATA(cmsg), cred, sizeof(*cred));

    msg.msg_name = NULL;
    msg.msg_namelen = 0;

    //设置要发送的数据
    buf[0] = v;
    iov.iov_base = buf;
    iov.iov_len = sizeof(buf);
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;

    if (sendmsg(sock, &msg, 0) < 0) {
        lxcfs_error("Failed at sendmsg: %s.\n",strerror(errno));
        if (errno == 3)
            return SEND_CREDS_NOTSK;
        return SEND_CREDS_FAIL;
    }

    return SEND_CREDS_OK;
}
```

### 接收端的例子

```c
// lxcfs/bindings.c: 2097
static bool recv_creds(int sock, struct ucred *cred, char *v)
{
    struct msghdr msg = { 0 };
    struct iovec iov;
    struct cmsghdr *cmsg;
    char cmsgbuf[CMSG_SPACE(sizeof(*cred))];
    char buf[1];
    int ret;
    int optval = 1;

    *v = '1';

    cred->pid = -1;
    cred->uid = -1;
    cred->gid = -1;

    if (setsockopt(sock, SOL_SOCKET, SO_PASSCRED, &optval, sizeof(optval)) == -1) {
        lxcfs_error("Failed to set passcred: %s\n", strerror(errno));
        return false;
    }
    buf[0] = '1';
    if (write(sock, buf, 1) != 1) {
        lxcfs_error("Failed to start write on scm fd: %s\n", strerror(errno));
        return false;
    }

    //准备用发送端同样规格的消息头
    msg.msg_name = NULL;
    msg.msg_namelen = 0;
    msg.msg_control = cmsgbuf;
    msg.msg_controllen = sizeof(cmsgbuf);

    iov.iov_base = buf;
    iov.iov_len = sizeof(buf);
    msg.msg_iov = &iov;
    msg.msg_iovlen = 1;

    if (!wait_for_sock(sock, 2)) {
        lxcfs_error("Timed out waiting for scm_cred: %s\n", strerror(errno));
        return false;
    }
    //接收数据
    ret = recvmsg(sock, &msg, MSG_DONTWAIT);
    if (ret < 0) {
        lxcfs_error("Failed to receive scm_cred: %s\n", strerror(errno));
        return false;
    }
    //读取额外的控制信息
    cmsg = CMSG_FIRSTHDR(&msg);

    if (cmsg && cmsg->cmsg_len == CMSG_LEN(sizeof(struct ucred)) &&
            cmsg->cmsg_level == SOL_SOCKET &&
            cmsg->cmsg_type == SCM_CREDENTIALS) {
        memcpy(cred, CMSG_DATA(cmsg), sizeof(*cred));
    }
    //buf中已经写入发送过来的数据
    *v = buf[0];

    return true;
}
```

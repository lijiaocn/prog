# IDEA远程调试python

Tools->Deployment->Configuration，在弹出的窗口中添加远程Server，根据需要选择FTP或者SFTP协议，这里使用SFTP。

添加远程server之后，先不要关闭窗口，到`Mapping`选项卡中，设置一下远程路径，代码将被上传到远程服务器的指定目录中。

远程机器上需要设置SFTP，sshd默认就启用了sftp，可以用下面的命令验证以下：

	sftp root@SERVER_ADDR

如果在IntellJ Ideal中Test SFTP Connection总是失败，在shell中执行下面的命令（认证方式选择OpenSSH config and authentication agent的时候）：

	ssh-add ~/.ssh/id_rsa

[SFTP Connection Failed](https://intellij-support.jetbrains.com/hc/en-us/community/posts/115000808830-SFTP-Connection-Failed)

Test SFTP Connection成功之后，点进Tools->Deployment->Upload to XXX，将代码上传到指定的服务器。

也可以在左侧的目录中选择要上传的目录，然后点击右键，选择Deployment->Upload to XXX。

鼠标在编辑窗口中是，按下shift+alt+command+x，会弹出服务器列表，选中之后就直接将当前文件上传了。



[1]: https://blog.csdn.net/u013982921/article/details/80904005 "IntelliJ IDEA远程调试python"
[2]: https://www.howtoforge.com/tutorial/how-to-setup-an-sftp-server-on-centos/ "How to setup an SFTP server on CentOS"

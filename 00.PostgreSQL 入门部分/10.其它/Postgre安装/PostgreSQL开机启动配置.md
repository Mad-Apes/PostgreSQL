安装完成后，切换到 root 用户。 进入到解压目录的 contrib/start-scripts/ 下。
执行 chmod a+x linux
复制linux文件到/etc/init.d目录下，更名为postgresql. cp linux /etc/init.d/postgresql
修改 postgresql 下的 prefix 和 PGDATA。根据自己的实际安装情况修改。
执行service postgresql start，就可以启动PostgreSQL服务  #service postgresql start
设置postgresql服务开机自启动   #chkconfig --add postgresql

#-------------------- VOPS 扩展 --------------------
#下载 VOPS 扩展程序。URL：https://github.com/postgrespro/vops  说明：为避免出现 row is too big 的错误。使用源码安装数据库，设置 with-blocksize。

#将vops所需要的文件 放入 /usr/local/postgresql-10.3/contrib/vops 文件夹下。具体文件见 vops安装文件 文件夹。

#注意文件夹 vops 的权限 设置为 777

#进入相应目录执行
cd /usr/local/postgresql-10.3/contrib/vops
make && make instal


#重启数据库  执行 create extension vops;

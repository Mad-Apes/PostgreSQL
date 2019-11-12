# 背景
```
做主从同步的目的就是实现db服务的高可用性.
通常是一台主数据库提供读写，然后把数据同步到另一台从库，然后从库不断apply从主库接收到的数据，从库不提供写服务，只提供读服务。
在postgresql中提供读写全功能的服务器称为primary database或master database，在接收主库同步数据的同时又能提供读服务的从库服务器称为hot standby server。
```
# 流复制详解
```
9.0开始提供的一种新的传递WAL 日志的方式, 只要primary 数据库 一产生日志, 就会传递到standby 数据库. (1,异步,2,同步) 两种方式. (9.2 增加了级联复制功能), 9.0之前, 主从需第三方同步拷贝

```
## 数据同步方式
```
在primary 提交事务时, 一定会等到WAL 日志传递到standby 后才返回, 这样可以得到standby 数据完全和 primary 数据库同步. 没有一点落后.(自动切换,可以达到零丢失)
```
## 数据异步同步方式
```
Primary 提交事务后,不必等日志传递到standby 就即可返回. 所以standby 数据库通常 比primary 落后很少.
```

# postgresql.conf文件参数配置
```
listener_addresses = '*' --可以是IP, 也可以是 ' * ' 替代.
wal_level = hot_standby --热备模式开启
max_wal_sender = 5 --可以并行设置几个流复制连接进程.( 几个从,设置几个)
wal_keep_segments = 10240 #重要配置 流复制
wal_send_timeout = 60s --可防止逻辑错误,延缓同步时间.
max_connections = 512 --standby此参数设置最好比primary 设置的要大.
archive_mode = on --允许归档
archive_command = 'cp %p /data/postgreslog/archivelog/%f' --归档路径
```

# 在主机上查看备机信息
```
select pid,application_name,client_addr,client_port,state,sync_state from pg_stat_replication;

pid	  application_name  	client_addr	     client_port   	state	sync_state
3613   	standby01      	192.168.138.143     	34490      	streaming	sync
3614  	standby02      	192.168.138.144      	44744      	streaming	potential
```

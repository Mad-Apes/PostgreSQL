pg ctl stop [-D DATADIR] [-m SHUTDOWN-MODE] [-W] [ -t SECS] [ -s]

-m 参数指定数据库使用什么模式停止.PostgreSQL 支持三种模式：smart、fast、immediate三种方式。默认方式是 fast。

# smart
```
    smart 模式会等待所有的活动事务提交完毕，并且客户端主动断开数据库连接之后才会关闭数据库
```

# fast
```
    fast 模式会回滚所有的活动事务，并且强制断开数据库的连接后关闭数据库
```

# immediate
```
    immediate 模式会立即停止所有的服务器进程，当数据库再次启动时，会进入恢复状态，一般 不推荐使用。
```

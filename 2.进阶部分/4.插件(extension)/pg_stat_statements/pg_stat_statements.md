vi $PGDATA/postgresql.conf    

shared_preload_libraries='pg_stat_statements'    
如果要跟踪IO消耗的时间，还需要打开如下参数

track_io_timing = on    
设置单条SQL的最长长度，超过被截断显示（可选）
track_activity_query_size = 2048    
三、配置pg_stat_statements采样参数
vi $PGDATA/postgresql.conf    

pg_stat_statements.max = 10000           # 在pg_stat_statements中最多保留多少条统计信息，通过LRU算法，覆盖老的记录。    
pg_stat_statements.track = all           # all - (所有SQL包括函数内嵌套的SQL), top - 直接执行的SQL(函数内的sql不被跟踪), none - (不跟踪)    
pg_stat_statements.track_utility = off   # 是否跟踪非DML语句 (例如DDL，DCL)， on表示跟踪, off表示不跟踪    
pg_stat_statements.save = on             # 重启后是否保留统计信息    
重启数据库

pg_ctl restart -m fast    

```
平均单次 io
select userid::regrole, dbid, query from pg_stat_statements order by (blk_read_time+blk_write_time)/calls desc limit 20;

累计 io
select userid::regrole, dbid, query from pg_stat_statements order by (blk_read_time+blk_write_time) desc limit 20;

top time sql
平均 time
select userid::regrole, dbid, query from pg_stat_statements order by mean_time desc limit 20;
累计 time
select userid::regrole, dbid, query from pg_stat_statements order by total_time desc limit 20;

不稳定，时快时慢
select userid::regrole, dbid, query from pg_stat_statements order by stddev_time desc limit 20;

top shared memory
select userid::regrole, dbid, query from pg_stat_statements order by (shared_blks_hit+shared_blks_dirtied) desc limit 20;

top temp memory
select userid::regrole, dbid, query from pg_stat_statements order by temp_blks_written desc limit 20;


```

2­­-函数

pg_stat_statements_reset() returns void

       pg_stat_statements_reset丢弃目前由pg_stat_statements统计的所有信息，默认情况下，这个函数只能运行在超级用户下。

 

3-配置变量

pg_stat_statements.max(integer)

       pg_stat_statements.max是最大追踪的统计数据数量(即，视图中的最大行数)。如果数据量大于最大值，那么执行最少的语句将会被丢弃(本人测试，如果语句执行次数都为1时，其次是时间久的数据被丢弃)，这个值默认是1000，这个变量在服务启动前设置。

 
pg_stat_statements.track(enum)

        pg_stat_statements.track控制统计数据规则，top用于追踪top-level statement(直接由客户端方发送的)，all还会追踪嵌套的statements(例如在函数中调用的statements)


pg_stat_statements.track_utility(boolen)

       pg_stat_statements.track_utility控制是否跟踪公共程序命令(utility commands)，公共程序命令是SELECT/INSERT/UPDATE/DELETE以外的命令，默认值是开启，只有超级用户可以更改此设置。


pg_stat_statements.save(boolean)

       pg_stat_statements.save指定在服务器关闭时，是否保存统计信息。如果设置off，服务关闭时，统计信息将不会保存。默认值是on。这个值只能够在postgresql.conf中或者命令行设置。


该模块需要额外的共享内存，内存大小大致为pg_stat_statements.max* track_activity_query_size。要注意的是，一旦模块被加载，即使pg_stat_statements.track设置为none，共享内存都会被消耗。


上面的都是一些需要掌握的知识，下面开始真正配置pg_stat_statements并且运行

首先要编写postgresql.conf

#postgresql.conf

#------------------------------------------------------------------------------

# PG_STAT_STATEMENTS OPTIONS

#------------------------------------------------------------------------------

shared_preload_libraries = 'pg_stat_statements'

custom_variable_classes = 'pg_stat_statements'

pg_stat_statements.max = 1000

pg_stat_statements.track = all

4-编译安装pg_stat_statements模块

进入postgresql的源码目录：

cd /home/proxy_pg/postgresql-9.1.3/contrib/pg_stat_statements

make

make install

#如果$pgpath/share/extension目录下存在pg_stat_statements--1.0.sql，说明安装成功了

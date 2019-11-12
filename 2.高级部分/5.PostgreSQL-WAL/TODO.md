# PostgreSQL 的三类日志
一、PostgreSQL有3种日志：
1）pg_log（数据库运行日志）   内容可读    默认关闭的，需要设置参数启动
2）pg_xlog（WAL 日志，即重做日志）    内容一般不具有可读性        强制开启
3）pg_clog（事务提交日志，记录的是事务的元数据）  内容一般不具有可读性    强制开启

pg_xlog和pg_clog一般是在$PGDATA/下面的文件夹下，pg_log默认路径是$PGDATA/pg_log，通常可自定义路径和文件名

[root@pg ~]# cd /home/pgsql/9.1/data/
You have mail in /var/spool/mail/root
[root@pg data]# ll
total 460
drwx------ 19 postgres postgres   4096 Nov 27 17:58 base
drwx------  2 postgres postgres   4096 Jan 13 18:58 global
drwx------  2 postgres postgres   4096 Jan 14 02:36 pg_clog     --clog
-rw-------  1 postgres postgres   3513 Dec  4 09:36 pg_hba.conf
-rw-------  1 postgres postgres   1636 Mar 31  2015 pg_ident.conf
drwx------  2 postgres postgres   4096 Jan 14 04:35 pg_log         --log
drwx------  4 postgres postgres   4096 Mar 31  2015 pg_multixact
drwx------  2 postgres postgres   4096 Dec 10 10:37 pg_notify
drwx------  2 postgres postgres   4096 Mar 31  2015 pg_serial
drwx------  2 postgres postgres   4096 Jan 14 10:23 pg_stat_tmp
drwx------  2 postgres postgres  20480 Jan 14 09:56 pg_subtrans
drwx------  3 postgres postgres   4096 Mar 31  2015 pg_tblspc
drwx------  2 postgres postgres   4096 Mar 31  2015 pg_twophase
-rw-------  1 postgres postgres      4 Mar 31  2015 PG_VERSION
drwx------  3 postgres postgres 360448 Jan 14 10:17 pg_xlog     --xlog
-rw-------  1 postgres postgres  19278 Jan  7 11:13 postgresql.conf
-rw-------  1 postgres postgres     56 Dec  4 09:39 postmaster.opts
-rw-------  1 postgres postgres     70 Dec 10 10:37 postmaster.pid
-rw-r--r--  1 postgres postgres    434 Mar 31  2015 serverlog


[postgres@pg data]$ more postgresql.conf
log_destination = 'stderr'                
logging_collector = on
log_directory = 'pg_log'                   ---可自定义路径
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'   ---日志文件名
log_line_prefix = '%t-%d-%h-%a :'          ---日志每行的标准格式

二、各个日志的作用
（1）pg_log
     这个日志一般是记录服务器与DB的状态，比如各种Error信息，定位慢查询SQL，数据库的启动关闭信息，发生checkpoint过于频繁等的告警信息，诸如此类。该日志有.csv格式和.log。建议使用.csv格式，因为它一般会按大小和时间自动切割，毕竟查看一个巨大的日志文件比查看不同时间段的多个日志要难得多。pg_log是可以被清理删除，压缩打包或者转移，同时并不影响DB的正常运行。当我们有遇到DB无法启动或者更改参数没有生效时，第一个想到的就是查看这个日志。

[postgres@pg pg_log]$ ll
total 155848
-rw------- 1 postgres postgres 10485794 Jan 11 05:43 postgresql-2016-01-11_032149.log
-rw------- 1 postgres postgres 10485800 Jan 11 08:47 postgresql-2016-01-11_054328.log
-rw------- 1 postgres postgres 10485815 Jan 11 09:34 postgresql-2016-01-11_084732.log
-rw------- 1 postgres postgres 10485818 Jan 11 12:34 postgresql-2016-01-11_093423.log
-rw------- 1 postgres postgres 10485774 Jan 11 16:51 postgresql-2016-01-11_123409.log
-rw------- 1 postgres postgres  7924560 Jan 11 23:59 postgresql-2016-01-11_165153.log
-rw------- 1 postgres postgres 10485850 Jan 12 03:48 postgresql-2016-01-12_000000.log
-rw------- 1 postgres postgres 10485801 Jan 12 09:50 postgresql-2016-01-12_034808.log
-rw------- 1 postgres postgres 10485990 Jan 12 13:41 postgresql-2016-01-12_095036.log
-rw------- 1 postgres postgres  9972298 Jan 12 23:58 postgresql-2016-01-12_134142.log
-rw------- 1 postgres postgres 10485773 Jan 13 10:35 postgresql-2016-01-13_000000.log
-rw------- 1 postgres postgres 10485851 Jan 13 16:00 postgresql-2016-01-13_103558.log
-rw------- 1 postgres postgres 10485783 Jan 13 21:33 postgresql-2016-01-13_160057.log
-rw------- 1 postgres postgres  3997576 Jan 14 00:00 postgresql-2016-01-13_213345.log
-rw------- 1 postgres postgres 10485855 Jan 14 04:35 postgresql-2016-01-14_000000.log
-rw------- 1 postgres postgres 10485808 Jan 14 10:25 postgresql-2016-01-14_043543.log
-rw------- 1 postgres postgres  1303365 Jan 14 11:00 postgresql-2016-01-14_102534.log

[postgres@pg pg_log]$ head -3 postgresql-2016-01-14_102534.log
2016-01-14 10:25:34 CST-tinadb-192.168.12.22-[unknown] :LOG:  duration: 2920.522 ms  statement: select package_name_statistics_single('com.hdc')
2016-01-14 10:25:35 CST-tinadb-192.168.12.166-[unknown] :LOG:  duration: 637.073 ms  statement: SELECT  id FROM t_sample_state ;
2016-01-14 10:25:35 CST-tinadb-192.168.12.22-[unknown] :LOG:  duration: 4395.549 ms  statement: select t_sfa_sample_tmp_cron_data_singer('DBM',1)

（2）pg_xlog
    这个日志是记录的Postgresql的WAL信息，也就是一些事务日志信息(transaction log)。默认单个大小是16M，源码安装的时候可以更改其大小（./configure --with-wal-segsize=target_value 参数，即可设置）这些日志会在定时回滚恢复(PITR)， 流复制(Replication Stream)以及归档时能被用到，这些日志是非常重要的，记录着数据库发生的各种事务信息，不得随意删除或者移动这类日志文件，不然你的数据库会有无法恢复的风险

    WAL：PostgreSQL在将缓存的数据刷入到磁盘之前，先写日志, 这就是PostgreSQL WAL ( Write-Ahead Log )方式，也就是预写日志方式

[postgres@pg pg_xlog]$ ll
...
-rw------- 1 postgres postgres 16777216 Jan 13 12:05 0000000100000F310000009D
-rw------- 1 postgres postgres 16777216 Jan 13 12:15 0000000100000F310000009E
-rw------- 1 postgres postgres 16777216 Jan 13 12:15 0000000100000F310000009F
-rw------- 1 postgres postgres 16777216 Jan 13 12:13 0000000100000F31000000A0
-rw------- 1 postgres postgres 16777216 Jan 13 12:15 0000000100000F31000000A1
---每一个大小都是16M
drwx------ 2 postgres postgres   499712 Jan 14 11:18 archive_status
[postgres@pg pg_xlog]$ cd archive_status
-rw------- 1 postgres postgres 0 Jan 14 14:39 0000000100000F310000002D.done
-rw------- 1 postgres postgres 0 Jan 14 14:37 0000000100000F310000002C.done
-rw------- 1 postgres postgres 0 Jan 14 14:35 0000000100000F310000002B.done
-rw------- 1 postgres postgres 0 Jan 14 14:32 0000000100000F310000002A.done
-rw------- 1 postgres postgres 0 Jan 14 14:31 0000000100000F3100000029.done
--每个pg_xlog完成了归档后，都会在这里面生成一个.done的文件


流复制主库pg_xlog
[root@pg pg_xlog]# ll -t |head -5
total 21004780
-rw------- 1 postgres postgres 16777216 Jan 14 14:37 0000000100000F310000002D  
-rw------- 1 postgres postgres 16777216 Jan 14 14:37 0000000100000F310000002C
-rw------- 1 postgres postgres 16777216 Jan 14 14:35 0000000100000F310000002B
-rw------- 1 postgres postgres 16777216 Jan 14 14:32 0000000100000F310000002A
-rw------- 1 postgres postgres 16777216 Jan 14 14:31 0000000100000F3100000029

主库归档日志：
[root@pg pg_xlog]# cd /home/pgsql/backup_new/archived_log/    ---自定义的归档路径
[root@pg archived_log]# ll -t |head -6
total 53182464
-rw------- 1 postgres postgres 16777216 Jan 14 14:39 0000000100000F310000002D    
-rw------- 1 postgres postgres 16777216 Jan 14 14:37 0000000100000F310000002C
-rw------- 1 postgres postgres 16777216 Jan 14 14:35 0000000100000F310000002B
-rw------- 1 postgres postgres 16777216 Jan 14 14:32 0000000100000F310000002A
-rw------- 1 postgres postgres 16777216 Jan 14 14:31 0000000100000F3100000029
---其实也是上面的pg_xlog，当已经拷贝到归档路径，就算完成了归档，archive_status里面就会有一个同名状态文件.done生成（对比上面的.done时间一致）

流复制从库pg_xlog
[root@pg-ro pg_xlog]# ll -t |head -5
total 1146884
-rw------- 1 postgres postgres 16777216 Jan 14 14:36 0000000100000F310000002D
-rw------- 1 postgres postgres 16777216 Jan 14 14:36 0000000100000F310000002C
-rw------- 1 postgres postgres 16777216 Jan 14 14:34 0000000100000F310000002B
-rw------- 1 postgres postgres 16777216 Jan 14 14:31 0000000100000F310000002A
-rw------- 1 postgres postgres 16777216 Jan 14 14:29 0000000100000F3100000029
---可以看到，每个时间都比主库晚1-2分钟，主库生成后传到从库的

[root@pg data]# du -sh *
285G	base
1.2M	global
48M	pg_clog
4.0K	pg_hba.conf
4.0K	pg_ident.conf
158M	pg_log
240K	pg_multixact
12K	  pg_notify
4.0K	pg_serial
700K	pg_stat_tmp
28M  pg_subtrans
3.5G	pg_tblspc
4.0K	pg_twophase
4.0K	PG_VERSION
21G	pg_xlog       ---除了base目录，这个pg_xlog日志占的空间最大
20K	postgresql.conf
4.0K	postmaster.opts
4.0K	postmaster.pid
4.0K	serverlog

说明：当你的归档或者流复制发生异常的时候，事务日志会不断地生成，有可能会造成你的磁盘空间被塞满，最终导致DB挂掉或者起不来。遇到这种情况不用慌，可以先关闭归档或者流复制功能，备份pg_xlog日志到其他地方，但不要删除。然后删除较早时间的的pg_xlog，有一定空间后再试着启动Postgres。


WAL补充：
1.说明
   postgresql数据库可以通过调整WAL参数控制日志写入磁盘的先后顺序。先将日志写入磁盘能够完全保证数据的完整性，在崩溃时可以恢复最近的事务；后写入磁盘，很难保证在崩溃时事务能够得到恢复，数据的结果也很难保证是真实正确的。

2.WAL相关参数（参考网络）
fsync = on                      # turns forced synchronization on or off
   该参数直接控制日志是否先写入磁盘。默认值是ON(先写入)。配置该参数为OFF，更新数据写入磁盘完全不用等待WAL的写入完成，
   节省了时间，提高了性能。其直接隐患是无法保证在系统崩溃时最近的事务能够得到恢复，也就无法保证相关数据的真实与正确性。

synchronous_commit = on         # synchronization level; on, off, or local
   该参数表明是否等待WAL完成后才返回给用户事务的状态信息，默认值是ON.因参数只是控制事务的状态反馈，因此对于数据的一致性不存在风险。
   但事务的状态信息影响着数据库的整个状态。该参数可以灵活的配置，对于业务没有严谨要求的事务可以配置为OFF，能够为系统的性能带来不小的提升。

wal_writer_delay = 200ms
   WAL writer进程的间歇时间。默认值是200ms。准确的配置应该根据自身系统的运行状况。如果时间过长可能造成WAL buffer
   的内存不足；反之过小将会引起WAL的不断的写入，对磁盘的IO也是很大考验。

commit_delay:
   一个已经提交的数据在WAL buffer中存放的时间，单位ms，默认值是0，不用延迟。非0值表示可能存在多个事务的WAL同时写入磁盘。
   如果设置为非0，表明了某个事务执行commit后不会立即写入WAL中，而仍存放在WAL buffer中，这样对于后面的事务申请WAL buffer时非常不利，尤其是提交事务较多的高峰期，可能引起WAL buffer内存不足。如果内存足够大，可以尽量延长该参数值，能够使数据集中写入这样降低了系统的IO，提高了性能。同样如果此时崩溃数据面临着丢失的危险。个人建议采用默认值，同时将WAL文件存放在IO性能好的磁盘上。

3.WAL日志的个数
3.1先看几个相关的参数
checkpoint_segments = 128               # in logfile segments, min 1, 16MB each
checkpoint_timeout = 20min              # range 30s-1h
checkpoint_completion_target = 0.5      # checkpoint target duration, 0.0 - 1.0
wal_keep_segments = 1024

checkpoint执行控制:
1）数据量达到checkpoint_segments*16M时，系统自动触发；
2）时间间隔达到checkpoint_timeout参数值时;
3）用户发出checkpoint命令时。

说明：
1）checkpoint_segments 值默认为 3，这个值较小，建议设置成32以上，如果业务很繁忙，这个参数还应该调大，当然在恢复时也意味着恢复时间较长，这个需要综合考虑。
2）checkpoint_timeout 默认5分钟，系统自动执行checkpoint之间的最大时间间隔，同样间隔越大介质恢复的时间越长。
3）checkpoint_completion_target 默读值为 0.5,这个通常保持默认值即可。表示每个checkpoint需要在checkpoints间隔时间的50%内完成。

3.2 最大的日志数据估计方法（网上介绍的，只能是个大概值，也有可能会超过）
    通常地说，WAL segment 最大个数不超过  (2+checkpoint_completion_target)*checkpoint_segments + 1
    在流复制环境下， WAL最大数不超过 wal_keep_segments+checkpoint_segments+1

3.3 主机 pg_xlog 日志数
[root@pg pg_xlog]# ll |wc -l
1284

3.4 清理pg_xlog
修改参数:
wal_keep_segments = 512

reload 配置文件:
pg_ctl reload -D $PGDATA

执行一次checkpoint

部分pg_xlog 日志已被删除，空间使用率降下去了，我们可以不手动操作，因为checkpoint操作数据库会自动执行，执行频率由参数checkpoint_timeout控制。

---记住千万不要直接物理删除rm之类的。

（3）pg_clog
   pg_clog这个文件也是事务日志文件，但与pg_xlog不同的是它记录的是事务的元数据(metadata)，这个日志告诉我们哪些事务完成了，哪些没有完成。这个日志文件一般非常小，但是重要性也是相当高，不得随意删除或者对其更改信息。

[root@pg-ro pg_clog]# ll -t |head -10
total 48904
-rw------- 1 postgres postgres  24576 Jan 14 14:41 0962
-rw------- 1 postgres postgres 262144 Jan 14 14:01 0961
-rw------- 1 postgres postgres 262144 Jan 14 04:19 0960
-rw------- 1 postgres postgres 262144 Jan 13 17:02 095F
-rw------- 1 postgres postgres 262144 Jan 13 06:02 095E
-rw------- 1 postgres postgres 262144 Jan 12 11:03 095D 

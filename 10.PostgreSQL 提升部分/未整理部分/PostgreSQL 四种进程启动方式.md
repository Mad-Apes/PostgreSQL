Postgres在启动后，可分别以一下四种形式启动进程：
SubPostmasterMain
AuxiliaryProcessMain
PostgresMain
PostmasterMain
SubPostmasterMain（–fork）
指明由postmaster派生
设置进程ID
初始化内存池
处理输入参数
运行相应的backend或子进程
–forkbackend或–forkboot
1） 关联到共享内存
2） 初始化共享内存访问（UsedShmemSegAddr）
3） 初始化AuxiliaryProcess
4） 创建共享内存和信号量
5） 启动AuxiliaryProcessMain

–forkavlauncher
1） 关联到共享内存
2） AutovacuumLauncherIAm()
3） 初始化共享内存访问（UsedShmemSegAddr）
4） 初始化AuxiliaryProcess
5） 创建共享内存和信号量
6） 启动AutoVacLauncherMain

–forkavworker
1） 关联到共享内存
2） AutovacuumLauncherIAm()
3） 初始化共享内存访问（UsedShmemSegAddr）
4） 初始化AuxiliaryProcess
5） 创建共享内存和信号量
6） 启动AutoVacWorkerMain

–forkarch
1） 启动PgArchiverMain

–forkcol
1） 启动PgstatCollectorMain

–forklog
1） 启动SysLoggerMain

AuxiliaryProcessMain（–boot）
设置进程ID
初始化内存池
设置路径、时间等变量
初始化GUC选项，处理输入参数
以BootstrapProcessing模式初始化一个backend：ipc, lock, file, storage, buffer
设置信号处理句柄
以NormalProcessing状态针对不同auxType分别进行以下处理
a) CheckerProcess
1） 启动CheckerModeMain
b) BooststrapProcess
1） BootstrapXLOG
2） 启动XLOG
3） 启动BootstrapModeMain
c) StartupProcess
1） 启动XLOG
2） 加载FreeSpaceMap
3） BuildFlatFiles(false)
d) BgWriterProcess
1） 初始化XLOG访问
2） 启动BackgroundWriterMain
e) WalWriterProcess
1） 初始化XLOG访问
2） 启动WalWriterMain
PostgresMain（–single）
设置进程ID
初始化内存池
设置路径、时间等变量
初始化GUC选项，处理输入参数和其他startup packet中的参数
设置信号处理句柄
初始化一个backend（无论它是否由postmaster生成）：ipc, lock, file, storage, buffer
启动XLOG
加载FreeSpaceMap
初始化进程
初始化表缓存和系统目录访问
处理预加载的库
转到MessageContext内存池
进入查询处理主循环
PostmasterMain
设置进程ID
初始化内存池
设置路径、时间等变量
初始化GUC选项，处理输入参数并载入hba和ident
设置共享内存和信号量，初始化共享数据结构
设置信号处理句柄
启动守护进程：
(1) syslogger：收集其他其他进程的日志输出，写入到文件
(2) stats daemon：通过UDP获取各backend的运行时统计信息
(3) autovacuum launcher：定期进行表空间的自动清理
由参数forkboot启动一个backend
绑定到TCP socket，监听连接请求

原文链接：https://blog.csdn.net/tencupofkaiwater/article/details/81252248

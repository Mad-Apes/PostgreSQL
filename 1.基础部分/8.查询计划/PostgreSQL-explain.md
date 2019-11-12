# EXPLAIN
## 用途
  explain 用于理解和优化SQL查询，它用于接受 SELECT | UPDATE | DELETE 之类的 SQL 命令，并返回查询计划，查询计划详细说明了执行 SQL 所采取的方法。
## 如何理解查询计划
```
  # 除去第一行之外，每一个 ——> 表示一个子动作
  # 执行计划的阅读顺序总是从后之前
  # width=0 表示只获取行的位置没有读取数据。开始读取数据后 width 的值肯定大于0

```

# seq scan , bitmap index scan 和 index scan

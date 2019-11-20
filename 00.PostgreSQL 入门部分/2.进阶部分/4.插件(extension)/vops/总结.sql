--vops 表 示例
DROP TABLE IF EXISTS "public"."tmp_stat_5s_uemr";
CREATE TABLE IF NOT EXISTS "public"."tmp_stat_5s_uemr" (
"sequence_id" int8
)
WITH (OIDS=FALSE)
;

DROP TABLE IF EXISTS "public"."vops_tmp_stat_5s_uemr";
CREATE TABLE IF NOT EXISTS "public"."vops_tmp_stat_5s_uemr" (
"sequence_id" vops_int8
)
WITH (OIDS=FALSE)
;
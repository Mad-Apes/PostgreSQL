
-- ----------------------------
-- Table structure for tmp_stat_5s_uemr
-- ----------------------------
DROP TABLE IF EXISTS "public"."tmp_stat_5s_uemr";
CREATE UNLOGGED TABLE IF NOT EXISTS "public"."tmp_stat_5s_uemr" (
"sequence_id" vops_int8,
"next_align" vops_int8,
"nature_align" vops_int8,
"time_range" vops_int8range,

"length" vops_int2,
"local_province" vops_int2,
"local_city" vops_int2,
"owner_province" vops_int2,
"owner_city" vops_int2,
"roaming_type" vops_int2,
"interface_type" vops_int2,
"xdr_id" vops_uuid,
"rat" vops_int2,
"imsi" vops_int8,
"imei" vops_int8,
"msisdn" vops_int8,
"mme_group_id" vops_int2,
"mme_code" vops_int2,
"mme_ue_s1ap_id" vops_int4,
"enb_id" vops_int4,
"cell_id" vops_int8,--升一级:全F问题
"pci" vops_int2,
"time" vops_int8,
"mr_type" vops_int2,
"phr" vops_float4,
"enb_received_power" vops_float4,
"ul_sinr" vops_float4,
"ta" vops_int2,
"aoa" vops_float4,
"serving_freq" vops_int4,--升一级:真实数据超限
"serving_rsrp" vops_float4,
"serving_rsrq" vops_float4,
"neighbor_cell_number" vops_int2,
"neighbor1_pci" vops_int2,
"neighbor1_freq" vops_int4,--升一级:真实数据超限
"neighbor1_rsrp" vops_float4,
"neighbor1_rsrq" vops_float4,
"neighbor2_pci" vops_int2,
"neighbor2_freq" vops_int4,--升一级:真实数据超限
"neighbor2_rsrp" vops_float4,
"neighbor2_rsrq" vops_float4,
"neighbor3_pci" vops_int2,
"neighbor3_freq" vops_int4,--升一级:真实数据超限
"neighbor3_rsrp" vops_float4,
"neighbor3_rsrq" vops_float4,
"neighbor4_pci" vops_int2,
"neighbor4_freq" vops_int4,--升一级:真实数据超限
"neighbor4_rsrp" vops_float4,
"neighbor4_rsrq" vops_float4,
"neighbor5_pci" vops_int2,
"neighbor5_freq" vops_int4,--升一级:真实数据超限
"neighbor5_rsrp" vops_float4,
"neighbor5_rsrq" vops_float4,
"neighbor6_pci" vops_int2,
"neighbor6_freq" vops_int4,--升一级:真实数据超限
"neighbor6_rsrp" vops_float4,
"neighbor6_rsrq" vops_float4,
"neighbor7_pci" vops_int2,
"neighbor7_freq" vops_int4,--升一级:真实数据超限
"neighbor7_rsrp" vops_float4,
"neighbor7_rsrq" vops_float4,
"neighbor8_pci" vops_int2,
"neighbor8_freq" vops_int4,--升一级:真实数据超限
"neighbor8_rsrp" vops_float4,
"neighbor8_rsrq" vops_float4
)
WITH (OIDS=FALSE)
;

/*
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."sequence_id" IS '原始码流自定义ID';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."next_align" IS '下一个要用的对齐时间。';

COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."length" IS '整个XDR所占用字节数';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."local_province" IS '省份';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."local_city" IS '城市区号';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."owner_province" IS '归属省份';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."owner_city" IS '归属城市';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."roaming_type" IS '漫游类型';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."interface_type" IS '接口类型';
--COMMENT ON COLUMN "public".."tmp_stat_5s_uemr"."xdr_id" IS 'XDR ID';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."rat" IS 'RAT类型';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."imsi" IS 'IMSI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."imei" IS 'IMEI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."msisdn" IS 'MSISDN';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."mme_group_id" IS 'MME Group ID';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."mme_code" IS 'MME Code';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."mme_ue_s1ap_id" IS 'UE的MME UE S1AP ID';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."enb_id" IS 'eNB ID';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."cell_id" IS 'ECI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."pci" IS 'PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."time" IS '测量时间';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."mr_type" IS '测量类型';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."phr" IS 'UE发射功率余量';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."enb_received_power" IS 'eNB接收功率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."ul_sinr" IS '上行信噪比';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."ta" IS '时间提前量';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."aoa" IS '到达角';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."serving_freq" IS '服务小区频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."serving_rsrp" IS '服务小区RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."serving_rsrq" IS '服务小区RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor_cell_number" IS '邻区信息个数';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor1_pci" IS '邻区1 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor2_pci" IS '邻区2 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor3_pci" IS '邻区3 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor4_pci" IS '邻区4 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor5_pci" IS '邻区5 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor6_pci" IS '邻区6 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor7_pci" IS '邻区7 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor8_pci" IS '邻区8 PCI';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor1_freq" IS '邻区1频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor2_freq" IS '邻区2频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor3_freq" IS '邻区3频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor4_freq" IS '邻区4频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor5_freq" IS '邻区5频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor6_freq" IS '邻区6频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor7_freq" IS '邻区7频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor8_freq" IS '邻区8频率';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor1_rsrp" IS '邻区1RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor2_rsrp" IS '邻区2RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor3_rsrp" IS '邻区3RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor4_rsrp" IS '邻区4RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor5_rsrp" IS '邻区5RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor6_rsrp" IS '邻区6RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor7_rsrp" IS '邻区7RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor8_rsrp" IS '邻区8RSRP';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor1_rsrq" IS '邻区1RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor2_rsrq" IS '邻区2RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor3_rsrq" IS '邻区3RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor4_rsrq" IS '邻区4RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor5_rsrq" IS '邻区5RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor6_rsrq" IS '邻区6RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor7_rsrq" IS '邻区7RSRQ';
COMMENT ON COLUMN "public"."tmp_stat_5s_uemr"."neighbor8_rsrq" IS '邻区8RSRQ';
*/

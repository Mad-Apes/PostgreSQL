#
# sample_csv.ctl -- Control file to load CSV input data
#
#    Copyright (c) 2007-2011, NIPPON TELEGRAPH AND TELEPHONE CORPORATION
#


# [<schema_name>.]table_name
OUTPUT = cfg_report_3
# database action
TRUNCATE=NO
ON_DUPLICATE_KEEP = NEW
#FILTER=bulkload_filter_cellmr_to_5s

# Input data location (absolute path)
INPUT = /home/postgres/data/cfg_report.csv
LOGFILE=/home/postgres/bulkload_test/logs/cfg_report_3.log
PARSE_BADFILE=/home/postgres/bulkload_test/logs/cfg_report_3.bad.log
DUPLICATE_BADFILE=/home/postgres/bulkload_test/logs/cfg_report_3.duplicate.log

# Input file type
TYPE = CSV
# CSV Fomart Parameters
QUOTE = "\""
ESCAPE = \
DELIMITER = "|"
NULL=""

SKIP=0
LIMIT=INFINITE
PARSE_ERRORS=INFINITE
DUPLICATE_ERRORS=INFINITE

WRITER=PARALLEL
VERBOSE =NO

#CSV_FIELDS=table_name,params_name,description,params_value,default_value,range_operator
#FINAL_FIELDS=table_name,table_name,table_name,params_value,table_name

CSV_FIELDS=AA,BB,CC,DD,EE,FF
FINAL_FIELDS=AA,AA,FF


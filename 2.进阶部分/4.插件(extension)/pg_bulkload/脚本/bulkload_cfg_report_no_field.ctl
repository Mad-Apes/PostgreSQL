#
# sample_csv.ctl -- Control file to load CSV input data
#
#    Copyright (c) 2007-2011, NIPPON TELEGRAPH AND TELEPHONE CORPORATION
#


# [<schema_name>.]table_name
OUTPUT = cfg_report
# database action
TRUNCATE=false
ON_DUPLICATE_KEEP = NEW
#FILTER=bulkload_filter_cellmr_to_5s

# Input data location (absolute path)
INPUT = /home/postgres/data/cfg_report.csv
LOGFILE=/home/postgres/bulkload_test/logs/cfg_report.log
PARSE_BADFILE=/home/postgres/bulkload_test/logs/cfg_report.bad.log
DUPLICATE_BADFILE=/home/postgres/bulkload_test/logs/cfg_report.duplicate.log

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

FORCE_NOT_NULL=table_name
#FORCE_NOT_NULL=default_value


WRITER=PARALLEL
VERBOSE =NO
